//
//  Data+EIP2333.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 12/7/20.
//  Copyright © 2020 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import CryptoSwift
import BigInt

private let LAMPORT_SALT_MIN_LENGTH = 4
private let LAMPORT_KEY_SIZE = 8160
private let LAMPORT_CHUNK_SIZE = 32

extension Data {
  func deriveRootSK() throws -> Data {
    guard self.count >= 32 else {
      throw EIP2333Error.wrongSize
    }
    return try self.hkdfModR()
  }
  
  func deriveChildSK(index: UInt32) throws -> Data {
    guard self.count == 32 else {
      throw EIP2333Error.wrongSize
    }
    let compressedLamportPK = try self.parentSKToLamportPK(index: index)
    return try compressedLamportPK.hkdfModR()
  }
  
  func parentSKToLamportPK(index: UInt32) throws -> Data {
    var salt = BigInt(index).data
    
    if salt.count < LAMPORT_SALT_MIN_LENGTH {
      salt.setLength(LAMPORT_SALT_MIN_LENGTH, appendFromLeft: true, negative: false)
    }
    let ikm = self
    let notIkm = Data(ikm.map({~$0}))
    
    let lamport0 = try ikm.ikmToLamportSK(salt: salt)
    let lamport1 = try notIkm.ikmToLamportSK(salt: salt)
    
    let lamport01 = lamport0 + lamport1
    var lamportPK = Data()
    
    lamportPK = lamport01.reduce(lamportPK) { (_, nextPartialResult) -> Data in
      lamportPK.append(nextPartialResult.sha256())
      return lamportPK
    }
    return lamportPK.sha256()
  }
  
  func ikmToLamportSK(salt: Data) throws -> [Data] {
    guard self.count == 32 else {
      throw EIP2333Error.wrongSize
    }
    let okm = try HKDF(password: self.bytes, salt: salt.bytes, info: nil, keyLength: LAMPORT_KEY_SIZE, variant: .sha2(.sha256)).calculate()
    return okm.chunked(into: LAMPORT_CHUNK_SIZE).map({Data($0)})
  }
}
