//
//  File.swift
//  
//
//  Created by Nail Galiaskarov on 3/11/21.
//

import Foundation
import TweetNacl
import CryptoSwift

public struct EthEncryptedData: Codable {
  public let nonce: String
  public let ephemPublicKey: String
  public let ciphertext: String
  
  public init(nonce: String, ephemPublicKey: String, ciphertext: String) {
    self.nonce = nonce
    self.ephemPublicKey = ephemPublicKey
    self.ciphertext = ciphertext
  }
}

public enum EthCryptoError: Error {
    case decryptionFailed
}

extension EthEncryptedData {
    public func decrypt(privateKey: String) throws -> String {
        let data = Data(hex: privateKey)
                
        let secretKey = try NaclBox.keyPair(fromSecretKey: data).secretKey
        
        guard let nonce = Data(base64Encoded: self.nonce),
              let cipherText = Data(base64Encoded: self.ciphertext),
              let ephemPublicKey = Data(base64Encoded: self.ephemPublicKey) else {
          throw EthCryptoError.decryptionFailed
        }
        
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

extension PrivateKeyEth1 {
  public func eth_publicKey() throws -> String {
    let publicKey = try NaclBox.keyPair(fromSecretKey: data()).publicKey
    
    return publicKey.toHexString()
  }
}
