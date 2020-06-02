//
//  SECP256k1EcdsaRecoverableSignature+Recover.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 4/25/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import MEW_wallet_iOS_secp256k1_package

extension secp256k1_ecdsa_recoverable_signature {
  mutating func recoverPublicKey(from hash: Data, compressed: Bool, context: OpaquePointer /*secp256k1_context*/) -> Data? {
    guard hash.count == 32 else { return nil }
    var publicKey = secp256k1_pubkey()
    var hashBytes = hash.bytes
        
    let result = secp256k1_ecdsa_recover(context, &publicKey, &self, &hashBytes)
    
    guard result != 0 else { return nil }
    let flags = compressed ? UInt32(SECP256K1_EC_COMPRESSED) : UInt32(SECP256K1_EC_UNCOMPRESSED)
    return publicKey.data(context: context, flags: flags)
  }
}
