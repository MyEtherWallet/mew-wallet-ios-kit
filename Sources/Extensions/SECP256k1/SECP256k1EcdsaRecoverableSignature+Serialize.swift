//
//  SECP256k1EcdsaRecoverableSignature+Serialize.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 4/25/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import libsecp256k1

extension secp256k1_ecdsa_recoverable_signature {
  
  mutating func serialized(context: OpaquePointer/*secp256k1_context*/) -> Data? {
    var serialized = Data(repeating: 0x00, count: 64)
    //swiftlint:disable identifier_name
    var v: Int32 = 0
    //swiftlint:enable identifier_name

    let result = serialized.withUnsafeMutableBytes { serializedBufferPointer -> Int32 in
      guard let serializedPointer = serializedBufferPointer.baseAddress?.assumingMemoryBound(to: UInt8.self) else { return 0}
      return withUnsafePointer(to: &self, { signaturePointer -> Int32 in
        return withUnsafeMutablePointer(to: &v, { vPointer -> Int32 in
          return secp256k1_ecdsa_recoverable_signature_serialize_compact(context, serializedPointer, vPointer, signaturePointer)
        })
      })
    }
    
    guard result != 0 else {
      return nil
    }
    switch v {
    case 0:
      serialized.append(0x00)
    case 1:
      serialized.append(0x01)
    default:
      return nil
    }
    return serialized
  }
}
