//
//  SECP256k1Pubkey+Data.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 4/25/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import libsecp256k1

enum SECP256k1PubkeyError: Error {
  case invalidPrivateKey
  case invalidData
}

extension secp256k1_pubkey {
  static func parse(publicKey: Data, context: OpaquePointer/*secp256k1_context*/) throws -> secp256k1_pubkey {
    guard publicKey.count == 33 || publicKey.count == 65 else {
      throw SECP256k1PubkeyError.invalidData
    }
    
    var key = secp256k1_pubkey()
    
    let result = publicKey.withUnsafeBytes { publicBufferPointer -> Int32 in
      guard let publicPointer = publicBufferPointer.baseAddress?.assumingMemoryBound(to: UInt8.self) else { return 0 }
      return secp256k1_ec_pubkey_parse(context, &key, publicPointer, publicKey.count)
    }
    if result == 0 {
      throw SECP256k1PubkeyError.invalidData
    }
    
    return key
  }
  
  init(privateKey: Data, context: OpaquePointer/*secp256k1_context*/) throws {
    self.init()
    let prvKey = privateKey.bytes
    
    let result = secp256k1_ec_pubkey_create(context, &self, prvKey)
    if result != 1 {
      throw SECP256k1PubkeyError.invalidPrivateKey
    }
  }
  
  mutating func data(context: OpaquePointer/*secp256k1_context*/, flags: UInt32) -> Data? {
    var serializedKey = UnsafeMutablePointer<UInt8>.allocate(capacity: 65)
    defer {
      serializedKey.deallocate()
    }
    
    var keySizeT: size_t = 65
    
    let result = secp256k1_ec_pubkey_serialize(context, serializedKey, &keySizeT, &self, flags)
    if result != 1 {
      return nil
    }
    
    return Data(bytes: serializedKey, count: keySizeT)
  }
}
