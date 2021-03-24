//
//  File.swift
//  
//
//  Created by Nail Galiaskarov on 3/11/21.
//

import Foundation
import TweetNacl
import CryptoSwift

public struct EthEncryptedData {
  let nonce: String
  let ephemPublicKey: String
  let ciphertext: String
}

public enum EthCryptoError: Error {
    case decryptionFailed
}

extension EthEncryptedData {
    public func decrypt(privateKey: String) throws -> String {
        let data = Data(hex: privateKey)
                
        let secretKey = try NaclBox.keyPair(fromSecretKey: data).secretKey
        
        let nonce = Data(base64Encoded: self.nonce)!
        let cipherText = Data(base64Encoded: self.ciphertext)!
        let ephemPublicKey = Data(base64Encoded: self.ephemPublicKey)!
        
        let decrypted = try NaclBox.open(
            message: cipherText,
            nonce: nonce,
            publicKey: ephemPublicKey,
            secretKey: secretKey
        )
        
        guard let message = String(data: decrypted, encoding: .utf8) else {
            throw EthCryptoError.decryptionFailed
        }
        
        return message
    }
}

extension Data {

    // From http://stackoverflow.com/a/40278391:
    init?(fromHexEncodedString string: String) {

        // Convert 0 ... 9, a ... f, A ...F to their decimal value,
        // return nil for all other input characters
        func decodeNibble(u: UInt16) -> UInt8? {
            switch(u) {
            case 0x30 ... 0x39:
                return UInt8(u - 0x30)
            case 0x41 ... 0x46:
                return UInt8(u - 0x41 + 10)
            case 0x61 ... 0x66:
                return UInt8(u - 0x61 + 10)
            default:
                return nil
            }
        }

        self.init(capacity: string.utf16.count/2)
        var even = true
        var byte: UInt8 = 0
        for c in string.utf16 {
            guard let val = decodeNibble(u: c) else { return nil }
            if even {
                byte = val << 4
            } else {
                byte += val
                self.append(byte)
            }
            even = !even
        }
        guard even else { return nil }
    }
}
