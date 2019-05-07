//
//  Data+SECP256k1.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 4/25/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import libsecp256k1
import CryptoSwift

extension Data {
  func secp256k1Verify(context: OpaquePointer/*secp256k1_context*/) -> Bool {
    guard self.count == 32 else { return false }
    let result = self.withUnsafeBytes { pointer -> Int32 in
      guard let pointer = pointer.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
        return 0
      }
      return secp256k1_ec_seckey_verify(context, pointer)
    }
    return result == 1
  }
  
  func secp256k1RecoverableSign(privateKey: Data, extraEntropy: Bool = false, context: OpaquePointer/*secp256k1_context*/) -> secp256k1_ecdsa_recoverable_signature? {
    guard self.count == 32, privateKey.count == 32 else { return nil }
    var signature = secp256k1_ecdsa_recoverable_signature()
    
    let result = self.withUnsafeBytes { dataBufferPointer -> Int32 in
      guard let dataPointer = dataBufferPointer.baseAddress?.assumingMemoryBound(to: UInt8.self) else { return 0 }
      return privateKey.withUnsafeBytes { keyBufferPointer -> Int32 in
        guard let keyPointer = keyBufferPointer.baseAddress?.assumingMemoryBound(to: UInt8.self) else { return 0 }
        
        let signaturePointer = UnsafeMutablePointer(&signature)
        
        if extraEntropy {
          guard let extraEntropy = Data.randomBytes(length: 32) else { return 0 }
          return extraEntropy.withUnsafeBytes { extraEntropyBufferPointer -> Int32 in
            guard let extraEntropyPointer = extraEntropyBufferPointer.baseAddress?.assumingMemoryBound(to: UInt8.self) else { return 0 }
            return secp256k1_ecdsa_sign_recoverable(context, signaturePointer, dataPointer, keyPointer, nil, extraEntropyPointer)
          }
        } else {
          return secp256k1_ecdsa_sign_recoverable(context, signaturePointer, dataPointer, keyPointer, nil, nil)
        }
      }
    }
    guard result != 0 else { return nil }
    return signature
  }
  
  func secp256k1ParseSignature(context: OpaquePointer/*secp256k1_context*/) -> secp256k1_ecdsa_recoverable_signature? {
    guard self.count == 65 else { return nil }
    var signature = secp256k1_ecdsa_recoverable_signature()
    var serialized = self[0 ..< 64]
    //swiftlint:disable identifier_name
    let v = Int32(self[64])
    //swiftlint:enable identifier_name
    
    let result = serialized.withUnsafeMutableBytes { serializedBufferPointer -> Int32 in
      guard let serializedPointer = serializedBufferPointer.baseAddress?.assumingMemoryBound(to: UInt8.self) else { return 0}
      
      return withUnsafeMutablePointer(to: &signature, { signaturePointer -> Int32 in
        return secp256k1_ecdsa_recoverable_signature_parse_compact(context, signaturePointer, serializedPointer, v)
      })
    }
    
    guard result != 0 else { return nil }
    return signature
  }
  
  func secp256k1RecoverPublicKey(hash: Data, context: OpaquePointer/*secp256k1_context*/) -> Data? {
    guard self.count == 65, hash.count == 32 else { return nil }
    guard var signature = self.secp256k1ParseSignature(context: context) else { return nil }
    guard let publicKey = signature.recoverPublicKey(from: hash, compressed: false, context: context) else { return nil }
    return publicKey
  }
}
