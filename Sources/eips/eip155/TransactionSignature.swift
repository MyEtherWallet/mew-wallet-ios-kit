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
  private(set) internal var r: MEWBigInt<UInt8>
  private(set) internal var s: MEWBigInt<UInt8>
  private(set) internal var v: MEWBigInt<UInt8>
  //swiftlint:enable identifier_name
  private let chainID: MEWBigInt<UInt8>
  
  var inferedChainID: MEWBigInt<UInt8>? {
    if self.r.isZero && self.s.isZero {
      return self.v
    } else if self.v == 27 || self.v == 28 {
      return nil
    } else {
      return (self.v - 35) / 2
    }
  }
  
  init(signature: Data, chainID: MEWBigInt<UInt8>? = nil) throws {
    guard signature.count == 65 else {
      throw TransactionSignatureError.invalidSignature
    }
    self.r = MEWBigInt<UInt8>(signature[0 ..< 32])
    self.s = MEWBigInt<UInt8>(signature[32 ..< 64])
    if let chainID = chainID {
      self.v = MEWBigInt<UInt8>(signature[64]) + 35 + chainID + chainID
    } else {
      self.v = MEWBigInt<UInt8>(signature[64]) + 27
    }
    
    self.chainID = chainID ?? MEWBigInt<UInt8>()
    self._normalize()
  }
  
  //swiftlint:disable identifier_name
  init(r: MEWBigInt<UInt8>, s: MEWBigInt<UInt8>, v: MEWBigInt<UInt8>, chainID: MEWBigInt<UInt8>? = nil) {
    self.r = r
    self.s = s
    self.v = v
    self.chainID = chainID ?? MEWBigInt<UInt8>()
    self._normalize()
  }
  
  init(r: String, s: String, v: String, chainID: MEWBigInt<UInt8>? = nil) throws {
    self.r = MEWBigInt<UInt8>(Data(hex: r).bytes)
    self.s = MEWBigInt<UInt8>(Data(hex: s).bytes)
    self.v = MEWBigInt<UInt8>(Data(hex: v).bytes)
    self.chainID = chainID ?? MEWBigInt<UInt8>()
    self._normalize()
  }
  //swiftlint:enable identifier_name
  
  func recoverPublicKey(transaction: Transaction, context: OpaquePointer/*secp256k1_context*/) -> Data? {
    guard !self.r.isZero, !self.s.isZero else { return nil }
    let inferedChainID = self.inferedChainID
    var normalizedV = MEWBigInt<UInt8>(0)
    if !self.chainID.isZero {
      normalizedV = self.v - 35 - 2 * self.chainID
    } else if inferedChainID != nil {
      normalizedV = self.v - 35 - 2 * inferedChainID!
    } else {
      normalizedV = self.v - 0x1B
    }
    let rData = self.r.data
    let sData = self.s.data
    
    let vData: Data
    if normalizedV.isZero {
      vData = Data([0x00])
    } else {
      vData = normalizedV.reversedData
    }
    
    let signature = rData + sData + vData
    guard let hash = transaction.hash(chainID: inferedChainID, forSignature: true) else { return nil }
    guard let publicKey = signature.secp256k1RecoverPublicKey(hash: hash, context: context) else { return nil }
    return publicKey
  }
  
  // MARK: - Private
  
  mutating func _normalize() {
    self.r.dataLength = 32
    self.s.dataLength = 32
    self.v.dataLength = 1
  }
  
  // MARK: - CustomDebugStringConvertible
  
  var debugDescription: String {
    var description = "Signature\n"
    description += "r: \(self.r.data.toHexString())\n"
    description += "s: \(self.s.data.toHexString())\n"
    description += "v: \(self.v.data.toHexString())\n"
    description += "chainID: \(self.chainID.data.toHexString())"
    return description
  }
}
