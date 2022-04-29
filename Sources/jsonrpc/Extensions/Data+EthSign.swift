//
//  Data+EthSign.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 7/24/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import MEW_wallet_iOS_secp256k1_package

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
  
  func sign(key: PrivateKeyEth1, leadingV: Bool) -> Data? {
    self.sign(key: key.data(), leadingV: leadingV)
  }
    
  /// Recovers address from a hashed message (self) with provided signature.
  ///
  /// Caller must compare returned Ethereum address with the sender's address and
  /// confirm the hash provided by the sender is equal to the hash of the original message
  /// - Parameter with signature: signature
  /// - Returns: Ethereum address that signed the message, nil if address could not be recovered
  func recover(with signature: Data) -> Address? {
    // Normalize V part of signature
    var signature = signature
    if signature[64] > 3 {
      signature[64] = signature[64] - 0x1b
    }
      
    let context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_VERIFY))!
    // Recover public key from signature and hash
    guard let publicKeyRecovered = signature.secp256k1RecoverPublicKey(hash: self, context: context),
          let publicKey = try? PublicKeyEth1(publicKey: publicKeyRecovered, index: 0, network: .ethereum) else {
      return nil
    }
    return publicKey.address()
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
      let signature = try TransactionSignature(signature: serializedRecoverableSignature, normalized: true)
      var signed = Data()
      if leadingV {
        signed.append(signature.v.data)
      }
      signed.append(signature.r.data)
      signed.append(signature.s.data)
      if !leadingV {
        signed.append(signature.v.data)
      }
      
      return signed
    } catch {
      return nil
    }
  }
}
