//
//  SECP256k1EcdsaRecoverableSignature+Serialize.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 4/25/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import MEW_wallet_iOS_secp256k1_package

extension secp256k1_ecdsa_recoverable_signature {
  
  mutating func serialized(context: OpaquePointer/*secp256k1_context*/) -> Data? {
    var serialized = Data(repeating: 0x00, count: 64).bytes
    // swiftlint:disable:next identifier_name
    var v: Int32 = 0

    let result = secp256k1_ecdsa_recoverable_signature_serialize_compact(context, &serialized, &v, &self)
    
    guard result != 0 else {
      return nil
    }
    switch v {
    case 0, 1:
      serialized.append(UInt8(v))
    default:
      return nil
    }
    return Data(serialized)
  }
}
