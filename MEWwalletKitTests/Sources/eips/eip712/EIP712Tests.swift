//
//  File.swift
//  
//
//  Created by Nail Galiaskarov on 3/19/21.
//

import Foundation

import CryptoSwift
import Foundation
import Quick
import Nimble
@testable import MEWwalletKit

class EIP712Tests: QuickSpec {
    private lazy var typedMessage: TypedMessage = {
        let types: MessageTypes = [
            "EIP712Domain": [
                .init(name: "name", type: "string"),
                .init(name: "version", type: "string"),
                .init(name: "chainId", type: "uint256"),
                .init(name: "verifyingContract", type: "address")
            ],
            "Person": [
                .init(name: "name", type: "string"),
                .init(name: "wallet", type: "address")
            ],
            "Mail": [
                .init(name: "from", type: "Person"),
                .init(name: "to", type: "Person"),
                .init(name: "contents", type: "string")
            ]
        ]
        let domain = TypedMessageDomain(
            name: "Ether Mail",
            version: "1",
            chainId: 1,
            verifyingContract: "0xCcCCccccCCCCcCCCCCCcCcCccCcCCCcCcccccccC"
        )
        
        let message: [String: Any] = [
            "from": [
                "name": "Cow",
                "wallet": "0xCD2a3d9F938E13CD947Ec05AbC7FE734Df8DD826"
            ],
            "to": [
                "name": "Bob",
                "wallet": "0xbBbBBBBbbBBBbbbBbbBbbbbBBbBbbbbBbBbbBBbB"
            ],
            "contents": "Hello, Bob!"
        ]
        
        return TypedMessage(
            types: types,
            primaryType: "Mail",
            domain: domain,
            message: message as [String: AnyObject]
        )
    }()
    
    private lazy var typedMessage_v4: TypedMessage = {
        let types: MessageTypes = [
            "EIP712Domain": [
                .init(name: "name", type: "string"),
                .init(name: "version", type: "string"),
                .init(name: "chainId", type: "uint256"),
                .init(name: "verifyingContract", type: "address")
            ],
            "Person": [
                .init(name: "name", type: "string"),
                .init(name: "wallets", type: "address[]")
            ],
            "Mail": [
                .init(name: "from", type: "Person"),
                .init(name: "to", type: "Person[]"),
                .init(name: "contents", type: "string")
            ],
            "Group": [
                .init(name: "name", type: "string"),
                .init(name: "members", type: "Person[]"),
            ]
        ]
        let domain = TypedMessageDomain(
            name: "Ether Mail",
            version: "1",
            chainId: 1,
            verifyingContract: "0xCcCCccccCCCCcCCCCCCcCcCccCcCCCcCcccccccC"
        )
        
        let message: [String: Any] = [
            "from": [
                "name": "Cow",
                "wallets": [
                    "0xCD2a3d9F938E13CD947Ec05AbC7FE734Df8DD826",
                    "0xDeaDbeefdEAdbeefdEadbEEFdeadbeEFdEaDbeeF"
                ]
            ],
            "to": [
                [
                    "name": "Bob",
                    "wallets": [
                        "0xbBbBBBBbbBBBbbbBbbBbbbbBBbBbbbbBbBbbBBbB",
                        "0xB0BdaBea57B0BDABeA57b0bdABEA57b0BDabEa57",
                        "0xB0B0b0b0b0b0B000000000000000000000000000"
                    ]
                ]
            ],
            "contents": "Hello, Bob!"
        ]
        
        return TypedMessage(
            types: types,
            primaryType: "Mail",
            domain: domain,
            message: message as [String: AnyObject]
        )
    }()
    
    private var typedMessageWithBytes32_v3: TypedMessage = {
        let types: MessageTypes = [
            "EIP712Domain": [
                .init(name: "name", type: "string"),
                .init(name: "version", type: "string"),
                .init(name: "chainId", type: "uint256"),
                .init(name: "verifyingContract", type: "address")
            ],
            "Bet": [
                .init(name: "roundId", type: "uint32"),
                .init(name: "gameType", type: "uint8"),
                .init(name: "number", type: "uint256"),
                .init(name: "value", type: "uint256"),
                .init(name: "balance", type: "int256"),
                .init(name: "serverHash", type: "bytes32"),
                .init(name: "userHash", type: "bytes32"),
                .init(name: "gameId", type: "uint256")
            ]
        ]
        let domain = TypedMessageDomain(
            name: "Dicether",
            version: "2",
            chainId: 1,
            verifyingContract: "0xaEc1F783B29Aab2727d7C374Aa55483fe299feFa"
        )
        
        let message: [String: Any] = [
            "roundId": 1,
            "gameType": 4,
            "num": 1,
            "value": "320000000000000",
            "balance": "-640000000000000",
            "serverHash": "0x4ed3c2d4c6acd062a3a61add7ecdb2fcfd988d944ba18e52a0b0d912d7a43cf4",
            "userHash": "0x6901562dd98a823e76140dc8728eca225174406eaa6bf0da7b0ab67f6f93de4d",
            "gameId": 2393,
            "number": 1
        ]
        
        return TypedMessage(
            types: types,
            primaryType: "Bet",
            domain: domain,
            message: message as [String: AnyObject]
        )
    }()
    
    private var typedMessageWithBytes_v3: TypedMessage = {
        let types: MessageTypes = [
            "EIP712Domain": [
                .init(name: "name", type: "string"),
                .init(name: "version", type: "string"),
                .init(name: "chainId", type: "uint256"),
                .init(name: "verifyingContract", type: "address")
            ],
            "Bet": [
                .init(name: "roundId", type: "uint32"),
                .init(name: "gameType", type: "uint8"),
                .init(name: "number", type: "uint256"),
                .init(name: "value", type: "uint256"),
                .init(name: "balance", type: "int256"),
                .init(name: "serverHash", type: "bytes"),
                .init(name: "userHash", type: "bytes32"),
                .init(name: "gameId", type: "uint256")
            ]
        ]
        let domain = TypedMessageDomain(
            name: "Dicether",
            version: "2",
            chainId: 1,
            verifyingContract: "0xaEc1F783B29Aab2727d7C374Aa55483fe299feFa"
        )
        
        let message: [String: Any] = [
            "roundId": 1,
            "gameType": 4,
            "num": 1,
            "value": "320000000000000",
            "balance": "-640000000000000",
            "serverHash": "0x4ed3c2d4c6acd062a3a61add7ecdb2",
            "userHash": "0x6901562dd98a823e76140dc8728eca225174406eaa6bf0da7b0ab67f6f93de4d",
            "gameId": 2393,
            "number": 1
        ]
        
        return TypedMessage(
            types: types,
            primaryType: "Bet",
            domain: domain,
            message: message as [String: AnyObject]
        )
    }()

    
    override func spec() {
        executeTestsSignTypeV3()
        executeTestsSignTypeWithBytes32V3()
        executeTestsSignTypeWithBytesV3()
        executeTestsSignTypeV4()
    }
    
    private func executeTestsSignTypeV3() {
        describe("verify encoding single type") {
            it("should encode data") {
                do {
                    let encoded = try encodedType(primaryType: "Mail", types: self.typedMessage.types)
                    let expected = "Mail(Person from,Person to,string contents)Person(string name,address wallet)"
                    expect(encoded).to(equal(expected))
                } catch {
                    fail(error.localizedDescription)
                }
            }
        }
        
        describe("typeHash") {
            it("should typeHash with primaryType Mail") {
                do {
                    let hash = try hashType(primaryType: "Mail", types: self.typedMessage.types)
                    let bytes = hash as! Array<UInt8>
                    let expected = "0xa0cedeb2dc280ba39b857546d74f5549c3a1d7bdc2dd96bf881f76108e23dac2"
                    expect(bytes.toHexString()).to(equal(expected.stringRemoveHexPrefix()))
                } catch {
                    fail(error.localizedDescription)
                }
            }
        }
        
        describe("encodeData v3") {
            it("should encode typed message with v3") {
                do {
                    let data = try encodeData(
                        primaryType: self.typedMessage.primaryType,
                        data: self.typedMessage.message,
                        types: self.typedMessage.types,
                        version: .v3
                    )
                    let result = """
                    0xa0cedeb2dc280ba39b857546d74f5549c3a1d7bdc2dd96bf881f76108e23dac2fc71e5fa27ff56c350aa531bc129ebdf613b772b6604664f5d8dbe21b85eb0c8cd54f074a4af31b4411ff6a60c9719dbd559c221c8ac3492d9d872b041d703d1b5aadf3154a261abdd9086fc627b61efca26ae5702701d05cd2305f7c52a2fc8
                    """
                    
                    expect(data.toHexString().stringAddHexPrefix()).to(equal(result))
                } catch {
                    fail(error.localizedDescription)
                }
            }
        }
        
        describe("structHash v3") {
            it("should correctly structHsh the message") {
                do {
                    let data = try hashStruct(
                        primaryType: self.typedMessage.primaryType,
                        data: self.typedMessage.message,
                        types: self.typedMessage.types,
                        version: .v3
                    ).toHexString()
                    let expected = "0xc52c0ee5d84264471806290a3f2c4cecfc5490626bf912d01f240d7a274b371e"
                    expect(data).to(equal(expected.stringRemoveHexPrefix()))
                } catch {
                    fail(error.localizedDescription)
                }
            }
        }
        
        describe("structHash domain v3") {
            it("should correctly structHsh the domain") {
                do {
                    let data = try hashStruct(
                        primaryType: "EIP712Domain",
                        data: self.typedMessage.domain.encoded(),
                        types: self.typedMessage.types,
                        version: .v3
                    ).toHexString()
                    let expected = "0xf2cee375fa42b42143804025fc449deafd50cc031ca257e0b194a650a912090f"
                    expect(data).to(equal(expected.stringRemoveHexPrefix()))
                } catch {
                    fail(error.localizedDescription)
                }
            }
        }

        describe("hash message") {
            it("it should correctly sign the typed message") {
                do {
                    let signed = try MEWwalletKit.hash(message: self.typedMessage, version: .v3)
                    let expected = "0xbe609aee343fb3c4b28e1df9e632fca64fcfaede20f02e86244efddf30957bd2"
                    expect(signed.toHexString()).to(equal(expected.stringRemoveHexPrefix()))
                } catch {
                    fail(error.localizedDescription)
                }
            }
        }
        
        describe("sign payload v3") {
            it("should sign payload") {
                do {
                    let pk = PrivateKeyEth1(privateKey: "cow".data(using: .utf8)!.sha3(.keccak256))
                    let payload = SignedMessagePayload(data: self.typedMessage, signature: nil)
                    
                    let signed = try signTypedMessage(privateKey: pk, payload: payload, version: .v3)
                    let expected = """
                    0x4355c47d63924e8a72e509b65029052eb6c299d53a04e167c5775fd466751c9d07299936d304c153f6443dfa05f40ff007d72911b6f72307f996231605b915621c
                    """
                    expect(signed).to(equal(expected.stringRemoveHexPrefix()))
                } catch {
                    fail(error.localizedDescription)
                }
            }
        }
    }
    
    private func executeTestsSignTypeV4() {
        describe("verify encoding single type v4") {
            it("should encode type") {
                do {
                    let encoded = try encodedType(primaryType: "Group", types: self.typedMessage_v4.types)
                    let expected = "Group(string name,Person[] members)Person(string name,address[] wallets)"
                    expect(encoded).to(equal(expected))
                } catch {
                    fail(error.localizedDescription)
                }
            }
        }
        
        describe("verify encoding Person type v4") {
            it("should encode type") {
                do {
                    let encoded = try encodedType(primaryType: "Person", types: self.typedMessage_v4.types)
                    let expected = "Person(string name,address[] wallets)"
                    expect(encoded).to(equal(expected))
                } catch {
                    fail(error.localizedDescription)
                }
            }
        }
        
        describe("verify encoding Mail type v4") {
            it("should encode type") {
                do {
                    let encoded = try encodedType(primaryType: "Mail", types: self.typedMessage_v4.types)
                    let expected = "Mail(Person from,Person[] to,string contents)Person(string name,address[] wallets)"
                    expect(encoded).to(equal(expected))
                } catch {
                    fail(error.localizedDescription)
                }
            }
        }

        describe("hash type Person v4") {
            it("should hash type") {
                do {
                    let hash = try hashType(primaryType: "Person", types: self.typedMessage_v4.types)
                    let bytes = hash as! Array<UInt8>
                    let expected = "0xfabfe1ed996349fc6027709802be19d047da1aa5d6894ff5f6486d92db2e6860"
                    expect(bytes.toHexString()).to(equal(expected.stringRemoveHexPrefix()))
                } catch {
                    fail(error.localizedDescription)
                }
            }
        }
        
        describe("encode data primary type Person v4") {
            it("it should encode data") {
                do {
                    let data = try encodeData(
                        primaryType: "Person",
                        data: self.typedMessage_v4.message["from"] as! [String: AnyObject],
                        types: self.typedMessage_v4.types,
                        version: .v4
                    )
                    let result = """
                    0xfabfe1ed996349fc6027709802be19d047da1aa5d6894ff5f6486d92db2e68608c1d2bd5348394761719da11ec67eedae9502d137e8940fee8ecd6f641ee16488a8bfe642b9fc19c25ada5dadfd37487461dc81dd4b0778f262c163ed81b5e2a
                    """
                    
                    expect(data.toHexString().stringAddHexPrefix()).to(equal(result))
                } catch {
                    fail(error.localizedDescription)
                }
            }
        }
        
        describe("hash struct from Person v4") {
            it("should hash struct with primary type person") {
                do {
                    let data = try hashStruct(
                        primaryType: "Person",
                        data: self.typedMessage_v4.message["from"] as! [String: AnyObject],
                        types: self.typedMessage_v4.types,
                        version: .v4
                    ).toHexString()
                    let expected = "0x9b4846dd48b866f0ac54d61b9b21a9e746f921cefa4ee94c4c0a1c49c774f67f"
                    expect(data).to(equal(expected.stringRemoveHexPrefix()))
                } catch let error as TypedMessageSignError {
                    fail(error.messageError())
                } catch {
                    fail(error.localizedDescription)
                }
            }
        }
        
        describe("pass arrays to v3") {
            it("should throw error and say use v4 instead") {
                do {
                    let _ = try hashStruct(
                        primaryType: "Person",
                        data: self.typedMessage_v4.message["from"] as! [String: AnyObject],
                        types: self.typedMessage_v4.types,
                        version: .v3
                    ).toHexString()
                    
                    fail("version v3 should not support arrays")
                } catch let error as TypedMessageSignError {
                    expect(error.messageError()).to(equal("Arrays are unimplemented in encoded data; use v4"))
                } catch {
                    fail(error.localizedDescription)
                }
            }
        }
        
        describe("hash struct to Person v4") {
            it("should hash struct with primary type person") {
                do {
                    let data = try hashStruct(
                        primaryType: "Person",
                        data: (self.typedMessage_v4.message["to"] as! [AnyObject]).first as! [String: AnyObject],
                        types: self.typedMessage_v4.types,
                        version: .v4
                    ).toHexString()
                    let expected = "0xefa62530c7ae3a290f8a13a5fc20450bdb3a6af19d9d9d2542b5a94e631a9168"
                    expect(data).to(equal(expected.stringRemoveHexPrefix()))
                } catch let error as TypedMessageSignError {
                    fail(error.messageError())
                } catch {
                    fail(error.localizedDescription)
                }
            }
        }
        
        describe("encodeData v4") {
            it("should encode typed message with v4") {
                do {
                    let data = try encodeData(
                        primaryType: self.typedMessage_v4.primaryType,
                        data: self.typedMessage_v4.message,
                        types: self.typedMessage_v4.types,
                        version: .v4
                    )
                    let result = """
                    0x4bd8a9a2b93427bb184aca81e24beb30ffa3c747e2a33d4225ec08bf12e2e7539b4846dd48b866f0ac54d61b9b21a9e746f921cefa4ee94c4c0a1c49c774f67fca322beec85be24e374d18d582a6f2997f75c54e7993ab5bc07404ce176ca7cdb5aadf3154a261abdd9086fc627b61efca26ae5702701d05cd2305f7c52a2fc8
                    """
                    
                    expect(data.toHexString().stringAddHexPrefix()).to(equal(result))
                } catch let error as TypedMessageSignError {
                    fail(error.messageError())
                } catch {
                    fail(error.localizedDescription)
                }
            }
        }
        
        describe("hash struct message v4") {
            it("should hash struct with primary type") {
                do {
                    let data = try hashStruct(
                        primaryType: self.typedMessage_v4.primaryType,
                        data: self.typedMessage_v4.message,
                        types: self.typedMessage_v4.types,
                        version: .v4
                    ).toHexString()
                    let expected = "0xeb4221181ff3f1a83ea7313993ca9218496e424604ba9492bb4052c03d5c3df8"
                    expect(data).to(equal(expected.stringRemoveHexPrefix()))
                } catch let error as TypedMessageSignError {
                    fail(error.messageError())
                } catch {
                    fail(error.localizedDescription)
                }
            }
        }
        
        describe("structHash domain v4") {
            it("should correctly structHsh the domain") {
                do {
                    let data = try hashStruct(
                        primaryType: "EIP712Domain",
                        data: self.typedMessage_v4.domain.encoded(),
                        types: self.typedMessage_v4.types,
                        version: .v4
                    ).toHexString()
                    let expected = "0xf2cee375fa42b42143804025fc449deafd50cc031ca257e0b194a650a912090f"
                    expect(data).to(equal(expected.stringRemoveHexPrefix()))
                } catch {
                    fail(error.localizedDescription)
                }
            }
        }

        describe("hash message v4") {
            it("it should correctly sign the typed message") {
                do {
                    let signed = try MEWwalletKit.hash(message: self.typedMessage_v4, version: .v4)
                    let expected = "0xa85c2e2b118698e88db68a8105b794a8cc7cec074e89ef991cb4f5f533819cc2"
                    expect(signed.toHexString()).to(equal(expected.stringRemoveHexPrefix()))
                } catch {
                    fail(error.localizedDescription)
                }
            }
        }
        
        describe("sign payload v4") {
            it("should sign payload") {
                do {
                    let pk = PrivateKeyEth1(privateKey: "cow".data(using: .utf8)!.sha3(.keccak256))
                    let payload = SignedMessagePayload(data: self.typedMessage_v4, signature: nil)
                    
                    let signed = try signTypedMessage(privateKey: pk, payload: payload, version: .v4)
                    let expected = """
                    0x65cbd956f2fae28a601bebc9b906cea0191744bd4c4247bcd27cd08f8eb6b71c78efdf7a31dc9abee78f492292721f362d296cf86b4538e07b51303b67f749061b
                    """
                    expect(signed).to(equal(expected.stringRemoveHexPrefix()))
                } catch {
                    fail(error.localizedDescription)
                }
            }
        }
    }
    
    private func executeTestsSignTypeWithBytes32V3() {
        describe("encode data with bytes32 fields v3") {
            it("should encode data") {
                do {
                    let expected = """
                    0xeef42e798af5b621c1fec054bfc1e4afbc802193bba58f0790a159f94e21fbac00000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000012309ce540000fffffffffffffffffffffffffffffffffffffffffffffffffffdb9ec635800004ed3c2d4c6acd062a3a61add7ecdb2fcfd988d944ba18e52a0b0d912d7a43cf46901562dd98a823e76140dc8728eca225174406eaa6bf0da7b0ab67f6f93de4d0000000000000000000000000000000000000000000000000000000000000959
                    """
                    
                    let data = try encodeData(
                        primaryType: self.typedMessageWithBytes32_v3.primaryType,
                        data: self.typedMessageWithBytes32_v3.message,
                        types: self.typedMessageWithBytes32_v3.types,
                        version: .v3
                    )
                    
                    expect(data.toHexString().stringAddHexPrefix()).to(equal(expected))
                } catch {
                    fail(error.localizedDescription)
                }
            }
            
            it("hash struct message with bytes32") {
                do {
                    let expected = "0x4b0bd1f29885f2aa4b88e192db2d43e26f110a0f6d6cc4c2601f20ead89421f9"
                    let data = try hashStruct(
                        primaryType: self.typedMessageWithBytes32_v3.primaryType,
                        data: self.typedMessageWithBytes32_v3.message,
                        types: self.typedMessageWithBytes32_v3.types,
                        version: .v3
                    )
                    
                    expect(data.toHexString()).to(equal(expected.stringRemoveHexPrefix()))
                } catch {
                    fail(error.localizedDescription)
                }
            }
            
            it("should sign the message") {
                let expected = "0xaf453442075953aced4d54ccf5773a486fd03d9c5a853a1163594209ba1c637409acf82e335e464487c375c4438e1bfc56725fd039255d4ddf33f7fcdafebe931b"
                let pk = PrivateKeyEth1(privateKey: Data(hex: "0x5a2ca5de56191208ba8f8d230c29fa2b0d93226743eb00f2fb7a33c9b3305edf"))
                
                do {
                    let payload = SignedMessagePayload(data: self.typedMessageWithBytes32_v3, signature: nil)
                    let signed = try signTypedMessage(privateKey: pk, payload: payload, version: .v4)
                    expect(signed).to(equal(expected.stringRemoveHexPrefix()))
                } catch {
                    fail(error.localizedDescription)
                }
            }
        }
    }
    
    func executeTestsSignTypeWithBytesV3() {
        describe("just simple bytes field type testing") {
            it("should encode") {
                do {
                    let expected = """
                    0x8347a0ac20020e98d8905ca3305686ec5ece8dddc65888708b6bdb38f98fddda00000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000012309ce540000fffffffffffffffffffffffffffffffffffffffffffffffffffdb9ec63580000f0a6235a818a0f89cd1941df12ddb53d8af3655c419d3283ee350ac6ec9fa2f96901562dd98a823e76140dc8728eca225174406eaa6bf0da7b0ab67f6f93de4d0000000000000000000000000000000000000000000000000000000000000959
                    """
                    
                    let data = try encodeData(
                        primaryType: self.typedMessageWithBytes_v3.primaryType,
                        data: self.typedMessageWithBytes_v3.message,
                        types: self.typedMessageWithBytes_v3.types,
                        version: .v3
                    )
                    
                    expect(data.toHexString().stringAddHexPrefix()).to(equal(expected))
                } catch {
                    fail(error.localizedDescription)
                }

            }
        }
    }
}
