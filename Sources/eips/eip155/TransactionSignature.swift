//
//  TransactionSignature.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 4/26/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import BigInt

enum TransactionSignatureError: Error {
  case invalidSignature
}

internal struct TransactionSignature: CustomDebugStringConvertible {
  // swiftlint:disable identifier_name
  private(set) internal var r: RLPBigInt
  private(set) internal var s: RLPBigInt
  private(set) internal var v: RLPBigInt

  private(set) internal var signatureYParity: RLPBigInt
  //swiftlint:enable identifier_name
  private let chainID: BigInt

  var inferedChainID: BigInt? {
    if self.r.value.isZero && self.s.value.isZero {
        return self.v.value
    } else if self.v.value == 27 || self.v.value == 28 {
        return nil
    } else {
        return (self.v.value - 35) / 2
    }
  }

  init(signature: Data, chainID: BigInt? = nil, normalized: Bool = false) throws {
    guard signature.count == 65 else {
      throw TransactionSignatureError.invalidSignature
    }
    self.r = RLPBigInt(value: BigInt(data: signature[0 ..< 32]))
    self.s = RLPBigInt(value: BigInt(data: signature[32 ..< 64]))
    self.signatureYParity = RLPBigInt(value: BigInt([signature[64]]))
    
    if let chainID = chainID {
        self.v = RLPBigInt(value: BigInt([signature[64]]) + 35 + chainID + chainID)
    } else {
        self.v = RLPBigInt(value: BigInt([signature[64]]) + 27)
    }

    self.chainID = chainID ?? BigInt()
    if normalized {
      self._normalize()
    }
  }

  // swiftlint:disable identifier_name
  init(r: BigInt, s: BigInt, v: BigInt, chainID: BigInt? = nil, normalized: Bool = false) {
    self.r = r.toRLP()
    self.s = s.toRLP()
    self.v = v.toRLP()
    self.signatureYParity = v.toRLP()
    self.chainID = chainID ?? BigInt()
    if normalized {
      self._normalize()
    }
  }

  init(r: String, s: String, v: String, chainID: BigInt? = nil, normalized: Bool = false) throws {
    self.r = BigInt(Data(hex: r).bytes).toRLP()
    self.s = BigInt(Data(hex: s).bytes).toRLP()
    self.v = BigInt(Data(hex: v).bytes).toRLP()
    self.signatureYParity = self.v

    self.chainID = chainID ?? BigInt()
    if normalized {
      self._normalize()
    }
  }
  // swiftlint:enable identifier_name

  func recoverPublicKey(transaction: Transaction, context: OpaquePointer/*secp256k1_context*/) -> Data? {
    guard !self.r.value.isZero, !self.s.value.isZero else { return nil }
    let inferedChainID = self.inferedChainID
    var normalizedV = BigInt(0)
    if !self.chainID.isZero {
        normalizedV = self.v.value - 35 - 2 * self.chainID
    } else if inferedChainID != nil {
        normalizedV = self.v.value - 35 - 2 * inferedChainID!
    } else {
        normalizedV = self.v.value - 0x1B
    }
    let rData = self.r.data
    let sData = self.s.data

    let vData: Data
    if normalizedV.isZero {
      vData = Data([0x00])
    } else {
      vData = normalizedV.data
    }
    let signature = rData.setLengthLeft(32) + sData.setLengthLeft(32) + vData.setLengthLeft(1)
    guard let hash = transaction.hash(chainID: inferedChainID, forSignature: true) else { return nil }
    guard let publicKey = signature.secp256k1RecoverPublicKey(hash: hash, context: context) else { return nil }
    return publicKey
  }
  
  // MARK: - Normalization
  
  private mutating func _normalize() {
    self.r.dataLength = 32
    self.s.dataLength = 32
    self.signatureYParity.dataLength = 1
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
