//
//  Data+EthSign.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 7/24/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import libsecp256k1

private let ethSignPrefix = "\u{19}Ethereum Signed Message:\n"

public extension Data {
  func hashPersonalMessage() -> Data? {
    var prefix = ethSignPrefix
    prefix += String(self.count)
    guard let prefixData = prefix.data(using: .ascii) else {
      return nil
    }
    let data = prefixData + self
    let hash = data.sha3(.keccak256)
    return hash
  }
  
  func sign(key: PrivateKey, leadingV: Bool) -> Data? {
    self.sign(key: key.data(), leadingV: leadingV)
  }
}

internal extension Data {
  func sign(key: Data, leadingV: Bool) -> Data? {
    var dataToSign: Data
    if self.count != 32 {
      guard let hash = self.hashPersonalMessage() else {
        return nil
      }
      dataToSign = hash
    } else {
      dataToSign = self
    }
    guard let context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN)) else {
      return nil
    }
    defer { secp256k1_context_destroy(context) }
    guard var recoverableSignature = dataToSign.secp256k1RecoverableSign(privateKey: key, context: context) else {
      return nil
    }
    guard let serializedRecoverableSignature = recoverableSignature.serialized(context: context) else {
      return nil
    }
    do {
      let signature = try TransactionSignature(signature: serializedRecoverableSignature)
      var signed = Data()
      if leadingV {
        signed.append(Data(signature.v._data))
      }
      signed.append(Data(signature.r._data))
      signed.append(Data(signature.s._data))
      if !leadingV {
        signed.append(Data(signature.v._data))
      }
      
      return signed
    } catch {
      return nil
    }
  }
}
