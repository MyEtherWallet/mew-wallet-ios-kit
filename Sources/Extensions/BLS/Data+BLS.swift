//
//  Data+BLS.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 12/7/20.
//  Copyright © 2020 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import bls_framework
import CryptoSwift
import BigInt

// "BLS-SIG-KEYGEN-SALT-"
private let HKDFMODR_SALT: [UInt8] = [0x42, 0x4c, 0x53, 0x2d, 0x53, 0x49, 0x47, 0x2d, 0x4b, 0x45, 0x59, 0x47, 0x45, 0x4e, 0x2d, 0x53, 0x41, 0x4c, 0x54, 0x2d]

extension Data {
  mutating func blsSecretKey() throws -> blsSecretKey {
    try BLSInterface.blsInit()
    
    var secretKey = bls_framework.blsSecretKey.init()
    var bytes = self.bytes
    blsSecretKeyDeserialize(&secretKey, &bytes, numericCast(bytes.count))
    return secretKey
  }
  
  mutating func blsPublicKey() throws -> blsPublicKey {
    try BLSInterface.blsInit()
    
    var secretKey = try self.blsSecretKey()
    return try secretKey.blsPublicKey()
  }
  
  func hkdfModR(keyInfo: Data = Data()) throws -> Data {
    var salt = HKDFMODR_SALT
    // swiftlint:disable identifier_name
    var sk = BigInt(0)
    let r = BigInt("52435875175126190479447740508185965837690552500527637822603658699938581184513", radix: 10)!
    // swiftlint:enable identifier_name
    
    while sk.isZero {
      salt = salt.sha256()
      let inputKeyingMaterial = self.bytes + [0x00]
      let info = keyInfo.bytes + [0x00, 0x30]
      
      let okm = try HKDF(password: inputKeyingMaterial, salt: salt, info: info, keyLength: 48, variant: .sha256).calculate()
      guard let okmBN = BigInt(Data(okm).toHexString(), radix: 16) else {
        throw EIP2333Error.invalidOKM
      }
      sk = okmBN % r
    }
    
    var result = sk.data
    result.setLength(32, appendFromLeft: true, negative: false) // make sure, length == 32
    return result
  }
}
