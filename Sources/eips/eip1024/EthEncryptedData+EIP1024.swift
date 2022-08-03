//
//  EthEncryptedData+EIP1024.swift
//  MEWwalletKit
//
//  Created by Nail Galiaskarov on 3/11/21.
//  Copyright © 2021 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import MEWwalletTweetNacl
import CryptoSwift

public struct EthEncryptedData: Codable {
  public let nonce: String
  public let ephemPublicKey: String
  public let ciphertext: String
  public private (set) var version = "x25519-xsalsa20-poly1305"
  
  public init(nonce: String, ephemPublicKey: String, ciphertext: String) {
    self.nonce = nonce
    self.ephemPublicKey = ephemPublicKey
    self.ciphertext = ciphertext
  }
}

public enum EthCryptoError: Error {
    case decryptionFailed
    case encryptionFailed
    case keyError
}

extension EthEncryptedData {
    
    // MARK: - Encrypt
    /// - Parameters:
    ///   - plaintext: plain text to be encrypted
    ///   - senderKey: private ethereum key of sender
    ///   - publicKey: public key of recipient curve25519 in hex format
    /// - Returns: EthEncryptedData
    public static func encrypt(plaintext: String, senderPrivateKey: PrivateKeyEth1, recipientPublicKey: String) throws -> EthEncryptedData {
        guard let plaintextData = plaintext.data(using: .utf8),
              let recipientPublicKey = Data(base64Encoded: recipientPublicKey) else {
            throw EthCryptoError.encryptionFailed
        }
        let secretBox = try TweetNacl.box(message: plaintextData, recipientPublicKey: recipientPublicKey, senderSecretKey: senderPrivateKey.curve25519PrivateKeyData())
        return try EthEncryptedData(nonce: secretBox.nonce.base64EncodedString(), ephemPublicKey: senderPrivateKey.curve25519PublicKey(), ciphertext: secretBox.box.base64EncodedString())
    }

    // MARK: - Decrypt
    /// Decrypts EthEncryptedData
    /// - Parameter privateKey: Private Ethereum key
    /// - Returns: cleartext message
    public func decrypt(privateKey: PrivateKeyEth1) throws -> String {
        guard let privateKey = privateKey.string() else { throw EthCryptoError.keyError }
        return try decrypt(privateKey: privateKey)
    }
    
    /// Decrypts EthEncryptedData
    /// - Parameter privateKey: String of private Ethereum key
    /// - Returns: cleartext message
    public func decrypt(privateKey: String) throws -> String {
        let data = Data(hex: privateKey)
                
        let secretKey = try TweetNacl.keyPair(fromSecretKey: data).secretKey
        
        guard let nonce = Data(base64Encoded: self.nonce),
              let cipherText = Data(base64Encoded: self.ciphertext),
              let ephemPublicKey = Data(base64Encoded: self.ephemPublicKey) else {
          throw EthCryptoError.decryptionFailed
        }
        
        let decrypted = try TweetNacl.open(
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
    
    
    /// Decrypt the message using the sender's private key
    /// - Parameters:
    ///   - senderPrivateKey: sender private key as PrivateKeyEth1
    ///   - recipientPublicKey: string of recipient's public key
    /// - Returns: cleartext message
    public func decrypt(senderPrivateKey: PrivateKeyEth1, recipientPublicKey: String) throws -> String {
        guard let privateKey = senderPrivateKey.string() else { throw EthCryptoError.keyError }
        return try decrypt(senderPrivateKey: privateKey, recipientPublicKey: recipientPublicKey)
    }
    
    /// Decrypt the message using the sender's private key
    /// - Parameters:
    ///   - senderPrivateKey: sender private key as string
    ///   - recipientPublicKey: string of recipient's public key
    /// - Returns: cleartext message
    public func decrypt(senderPrivateKey: String, recipientPublicKey: String) throws -> String {
        let data = Data(hex: senderPrivateKey)
                
        let secretKey = try TweetNacl.keyPair(fromSecretKey: data).secretKey
        
        guard let nonce = Data(base64Encoded: self.nonce),
              let cipherText = Data(base64Encoded: self.ciphertext),
              let recipientPublicKeyData = Data(base64Encoded: recipientPublicKey) else {
          throw EthCryptoError.decryptionFailed
        }
        
        let decrypted = try TweetNacl.open(
            message: cipherText,
            nonce: nonce,
            publicKey: recipientPublicKeyData,
            secretKey: secretKey
        )
        
        guard let message = String(data: decrypted, encoding: .utf8) else {
            throw EthCryptoError.decryptionFailed
        }
        
        return message
    }
}

extension PrivateKeyEth1 {
    
  /// Create curve25519 public key from Ethereum private key
  /// - Returns: base64 encoded string
  public func curve25519PublicKey() throws -> String {
    return try curve25519PublicKeyData().base64EncodedString()
  }

  /// Create curve25519 public key from Ethereum private key
  /// - Returns: public key
  func curve25519PublicKeyData() throws -> Data {
    return try TweetNacl.keyPair(fromSecretKey: data()).publicKey
  }

  /// Create curve25519 private key from Ethereum private key
  /// - Returns: base64 encoded string
  public func curve25519PrivateKey() throws -> String {
    return try curve25519PrivateKeyData().base64EncodedString()
  }
    
  /// Create curve25519 private key from Ethereum private key
  /// - Returns: private key
  func curve25519PrivateKeyData() throws -> Data {
    return try TweetNacl.keyPair(fromSecretKey: data()).secretKey
  }
}
