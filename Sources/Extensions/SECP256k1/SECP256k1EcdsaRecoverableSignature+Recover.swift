//
//  SECP256k1EcdsaRecoverableSignature+Recover.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 4/25/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import libsecp256k1

extension secp256k1_ecdsa_recoverable_signature {
  mutating func recoverPublicKey(from hash: Data, compressed: Bool, context: OpaquePointer /*secp256k1_context*/) -> Data? {
    guard hash.count == 32 else { return nil }
    var publicKey = secp256k1_pubkey()
    let result = hash.withUnsafeBytes { hashBuffer -> Int32 in
      guard let hashPointer = hashBuffer.baseAddress?.assumingMemoryBound(to: UInt8.self) else { return 0}
      
      return withUnsafePointer(to: &self, { signaturePointer -> Int32 in
        return withUnsafeMutablePointer(to: &publicKey, { publicKeyPointer -> Int32 in
          return secp256k1_ecdsa_recover(context, publicKeyPointer, signaturePointer, hashPointer)
        })
      })
    }
    
    guard result != 0 else { return nil }
    let flags = compressed ? UInt32(SECP256K1_EC_COMPRESSED) : UInt32(SECP256K1_EC_UNCOMPRESSED)
    return publicKey.data(context: context, flags: flags)
  }
}
