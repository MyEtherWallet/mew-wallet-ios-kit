//
//  TransactionSignature.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 4/26/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation

enum TransactionSignatureError: Error {
  case invalidSignature
}

internal struct TransactionSignature: CustomDebugStringConvertible {
  //swiftlint:disable identifier_name
  internal let r: BigInt<UInt8>
  internal let s: BigInt<UInt8>
  internal let v: BigInt<UInt8>
  //swiftlint:enable identifier_name
  private let chainID: BigInt<UInt8>
  
  var inferedChainID: BigInt<UInt8>? {
    if self.r.isZero && self.s.isZero {
      return self.v
    } else if self.v == 27 || self.v == 28 {
      return nil
    } else {
      return (self.v - 35) / 2
    }
  }
  
  init(signature: Data, chainID: BigInt<UInt8>) throws {
    guard signature.count == 65 else {
      throw TransactionSignatureError.invalidSignature
    }
    self.r = BigInt<UInt8>(signature[0 ..< 32])
    self.s = BigInt<UInt8>(signature[32 ..< 64])
    self.v = BigInt<UInt8>(signature[64]) + 35 + chainID + chainID
    self.chainID = chainID
  }
  
  //swiftlint:disable identifier_name
  init(r: BigInt<UInt8>, s: BigInt<UInt8>, v: BigInt<UInt8>, chainID: BigInt<UInt8>? = nil) {
    self.r = r
    self.s = s
    self.v = v
    self.chainID = chainID ?? BigInt<UInt8>()
  }
  
  init(r: String, s: String, v: String, chainID: BigInt<UInt8>? = nil) throws {
    self.r = BigInt<UInt8>(Data(hex: r).bytes)
    self.s = BigInt<UInt8>(Data(hex: s).bytes)
    self.v = BigInt<UInt8>(Data(hex: v).bytes)
    self.chainID = chainID ?? BigInt<UInt8>()
  }
  //swiftlint:enable identifier_name
  
  func recoverPublicKey(transaction: Transaction, context: OpaquePointer/*secp256k1_context*/) -> Data? {
    guard !self.r.isZero, !self.s.isZero else { return nil }
    let inferedChainID = self.inferedChainID
    var normalizedV = BigInt<UInt8>(0)
    if !self.chainID.isZero {
      normalizedV = self.v - 35 - 2 * self.chainID
    } else if inferedChainID != nil {
      normalizedV = self.v - 35 - 2 * inferedChainID!
    } else {
      normalizedV = self.v - 27
    }
    var rData = Data(self.r._data)
    rData.setLength(32)
    
    var sData = Data(self.s._data)
    sData.setLength(32)
    
    let vData: Data
    if normalizedV.isZero {
      vData = Data([0x00])
    } else {
      vData = Data(normalizedV._data.reversed())
    }
    
    let signature = rData + sData + vData
    guard let hash = transaction.hash(chainID: inferedChainID, forSignature: true) else { return nil }
    guard let publicKey = signature.secp256k1RecoverPublicKey(hash: hash, context: context) else { return nil }
    return publicKey
  }
  
  // MARK: - CustomDebugStringConvertible
  
  var debugDescription: String {
    var description = "Signature\n"
    description += "r: \(self.r._data.toHexString())\n"
    description += "s: \(self.s._data.toHexString())\n"
    description += "v: \(self.v._data.toHexString())\n"
    description += "chainID: \(self.chainID._data.toHexString())"
    return description
  }
}
