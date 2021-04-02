//
//  File.swift
//  
//
//  Created by Nail Galiaskarov on 3/16/21.
//

import Foundation
import CryptoSwift

public enum TypedMessageSignError: Error {
    case invalidData
    case unknown(String)
    
    func messageError() -> String {
        switch self {
        case .unknown(let string):
            return string
        case .invalidData:
            return "Invalid data"
        }
    }
}

public enum SignTypedDataVersion {
    case v3, v4
}

public struct MessageTypeProperty: Codable {
    public let name: String
    public let type: String
}

public struct TypedMessageDomain: Codable {
    public let name: String?
    public let version: String?
    public let chainId: Int?
    public let verifyingContract: String?
    
    public init(
        name: String?,
        version: String?,
        chainId: Int?,
        verifyingContract: String?
    ) {
        self.name = name
        self.version = version
        self.chainId = chainId
        self.verifyingContract = verifyingContract
    }
    
    func encoded() -> [String: AnyObject] {
        guard let data = try? JSONEncoder().encode(self) else {
            return [:]
        }
        
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        return (json as? [String: AnyObject]) ?? [:]
    }
}

public typealias MessageTypes = [String: [MessageTypeProperty]]

public struct SignedMessagePayload {
    public let data: TypedMessage
    public let signature: String?
    
    public init(
        data: TypedMessage,
        signature: String?
    ) {
        self.data = data
        self.signature = signature
    }
}

public struct TypedMessage {
    public let types: MessageTypes
    public let primaryType: String
    public let domain: TypedMessageDomain
    public let message: [String: AnyObject]
}

public extension TypedMessage {
    private enum CodingKeys: String {
        case types
        case primaryType
        case domain
        case message
    }
    
    init(json: [String: Any]) throws {
        guard
            let primaryType = json[CodingKeys.primaryType.rawValue] as? String
        else {
            throw TypedMessageSignError.invalidData
        }
        
        let types = (json[CodingKeys.types.rawValue] as? [String: Any]) ?? [:]
        var messageTypes = MessageTypes()
        try types.forEach {
            if let json = $0.value as? [[String: Any]] {
                let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                messageTypes[$0.key] = try JSONDecoder().decode([MessageTypeProperty].self, from: data)
            }
        }
        self.types = messageTypes
        
        self.primaryType = primaryType
        
        let domain = (json[CodingKeys.domain.rawValue] as? [String: Any]) ?? [:]
        let domainData = try JSONSerialization.data(withJSONObject: domain, options: .prettyPrinted)
        self.domain = try JSONDecoder().decode(TypedMessageDomain.self, from: domainData)
        
        self.message = (json[CodingKeys.message.rawValue] as? [String: AnyObject]) ?? [:]
    }
}

public func signTypedMessage(privateKey: Data, payload: SignedMessagePayload, version: SignTypedDataVersion = .v3) throws -> String {
    let message = try hash(message: payload.data, version: version)
    
    let key = PrivateKeyEth1(privateKey: privateKey)
    guard let signed = message.sign(key: key, leadingV: false) else {
        throw TypedMessageSignError.unknown("Failed to sign the message")
    }
    
    return signed.toHexString()
}

public func hash(message: TypedMessage, version: SignTypedDataVersion) throws -> Data {
    var data = Data(hex: "1901")
    
    data.append(
        try hashStruct(
            primaryType: "EIP712Domain",
            data: message.domain.encoded(),
            types: message.types,
            version: version
        )
    )
    
    if message.primaryType != "EIP712Domain" {
        data.append(
            try hashStruct(
                primaryType: message.primaryType,
                data: message.message,
                types: message.types,
                version: version
            )
        )
    }
    
    return data.sha3(.keccak256)
}

public func hashStruct(
    primaryType: String,
    data: [String: AnyObject],
    types: MessageTypes,
    version: SignTypedDataVersion
) throws -> Data {
    let data = try encodeData(
        primaryType: primaryType,
        data: data,
        types: types,
        version: version
    )
    return data.sha3(.keccak256)
}

public func encodeData(
    primaryType: String,
    data: [String: AnyObject],
    types: MessageTypes,
    version: SignTypedDataVersion
) throws -> Data {
    var encodedTypes = ["bytes32"]
    var encodedValues: [AnyObject] = [try hashType(primaryType: primaryType, types: types)]
    
    func encodeField(name: String, type: String, value: AnyObject?) throws -> (type: String, value: AnyObject) {
        if types[type] != nil {
            // value ???
            let encodedValue = value == nil ?
                Data(hex: "0x0000000000000000000000000000000000000000000000000000000000000000") :
                try encodeData(
                    primaryType: type,
                    data: value as! [String : AnyObject],
                    types: types,
                    version: version
                ).sha3(.keccak256)
            return (
                type: "bytes32",
                value: encodedValue.bytes as AnyObject
            )
        }
        
        guard let value = value else {
            throw TypedMessageSignError.unknown("missing value for field \(name) of type \(type)")
        }
        
        if type == "bytes" {
            guard let data = ABIEncoder.convertToData(value) else {
                throw TypedMessageSignError.unknown("failed to convert value \(value) to data")
            }
            
            return (type: "bytes32", value: data.sha3(.keccak256).bytes as AnyObject)
        }
        
        if type == "string" {
            let string = value as! String
            let data = string.data(using: .utf8)!
            
            return (type: "bytes32", value: data.sha3(.keccak256).bytes as AnyObject)
        }
        
        // TODO: check with metamask test cases v4
        if (type.last == "]") {
            guard version == .v4 else {
                throw TypedMessageSignError.unknown("Arrays are unimplemented in encoded data; use v4")
            }
            
            guard let index = type.lastIndex(of: "[") else {
                throw TypedMessageSignError.unknown("Bad array format")
            }
            
            let parsedType = String(type[..<index])
            let array: Array<AnyObject>
            if let objects = value as? [AnyObject] {
                array = objects
            } else {
                array = Array(arrayLiteral: value)
            }
            let typeValuePairs: [(type: ABI.Element.ParameterType, value: AnyObject)] = try array.map {
                let encoded = try encodeField(name: name, type: parsedType, value: $0)
                let abiType = try ABITypeParser.parseTypeString(encoded.type)
                return (type: abiType, value: encoded.value)
            }
            
            guard
                let data = ABIEncoder.encode(
                    types: typeValuePairs.map { $0.type },
                    values: typeValuePairs.map { $0.value }
                )
            else {
                throw TypedMessageSignError.unknown("Failed to abi encode")
            }
            
            return (
                type: "bytes32",
                value: data.sha3(.keccak256).bytes as AnyObject
            )
        }
        
        return (type: type, value: value)
    }
        
    for field in types[primaryType]! {
        let result = try encodeField(
            name: field.name,
            type: field.type,
            value: data[field.name]
        )
        encodedTypes.append(result.type)
        encodedValues.append(result.value)        
    }
        
    let types = try encodedTypes.map {
        try ABITypeParser.parseTypeString($0)
    }
    
    guard let encodedData = ABIEncoder.encode(types: types, values: encodedValues) else {
        throw TypedMessageSignError.unknown("Failed to abi encode")
    }
    return encodedData
}

public func hashType(primaryType: String, types: MessageTypes) throws -> AnyObject {
    let encoded = try encodedType(primaryType: primaryType, types: types)
    guard let data = encoded.data(using: .ascii)?.sha3(.keccak256) else {
        throw TypedMessageSignError.unknown("Invalid encoded data: \(encoded)")
    }
    
    return data.bytes as AnyObject
}

public func encodedType(primaryType: String, types: MessageTypes) throws -> String {
    var result = ""
    var deps = findTypeDependencies(primaryType: primaryType, types: types).filter {
        $0 != primaryType
    }
    
    deps = [primaryType] + deps.sorted()
    for type in deps {
        guard let children = types[type] else {
            throw TypedMessageSignError.unknown("No type definition specified: \(type)")
        }
        
        let joined = children
            .map { "\($0.type) \($0.name)"}
            .joined(separator: ",")
        
        result += "\(type)(\(joined))"
    }
    
    return result
}

func findTypeDependencies(primaryType: String, types: MessageTypes, results: [String] = []) -> [String] {
    let primaryType = primaryType.match(for: "^\\w*") ?? primaryType
    var results = results
    
    if (results.contains(primaryType)) {
        return results
    }
    
    guard let properties = types[primaryType] else {
        return results
    }
    
    results.append(primaryType)
    
    for field in properties {
        for dep in findTypeDependencies(primaryType: field.type, types: types, results: results) {
            if !results.contains(dep) {
                results.append(dep)
            }
        }
    }
    
    return results
}
