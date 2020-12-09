//
//  PublicKeyEth1.swift
//  MEWwalletKitTests
//
//  Created by Mikhail Nikanorov on 4/17/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import MEW_wallet_iOS_secp256k1_package

private struct PublicKeyEth1Constants {
  static let compressedKeySize = 33
  static let decompressedKeySize = 65
  
  static let compressedFlags = UInt32(SECP256K1_EC_COMPRESSED)
  static let decompressedFlags = UInt32(SECP256K1_EC_UNCOMPRESSED)
}

private struct PublicKeyEth1Config {
  private let compressed: Bool
  
  var keySize: Int {
    return self.compressed ? PublicKeyEth1Constants.compressedKeySize : PublicKeyEth1Constants.decompressedKeySize
  }
  
  var keyFlags: UInt32 {
    return self.compressed ? PublicKeyEth1Constants.compressedFlags : PublicKeyEth1Constants.decompressedFlags
  }
  
  init(compressed: Bool) {
    self.compressed = compressed
  }
}

public struct PublicKeyEth1: PublicKey {
  private let raw: Data
  private let chainCode: Data
  private let depth: UInt8
  private let fingerprint: Data
  private let index: UInt32
  public let network: Network
  private let config: PublicKeyEth1Config
  
  init(privateKey: Data, compressed: Bool = false, chainCode: Data, depth: UInt8, fingerprint: Data, index: UInt32, network: Network) throws {
    self.config = PublicKeyEth1Config(compressed: compressed)
    guard var context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN)) else {
      throw PublicKeyError.internalError
    }
    defer { secp256k1_context_destroy(context) }
    
    var pKey = try secp256k1_pubkey(privateKey: privateKey, context: context)
    
    guard let rawData = pKey.data(context: context, flags: self.config.keyFlags) else {
      throw PublicKeyError.internalError
    }
    self.raw = rawData
    self.chainCode = chainCode
    self.depth = depth
    self.fingerprint = fingerprint
    self.index = index
    self.network = network
  }
  
  init(publicKey: Data, compressed: Bool? = false, index: UInt32, network: Network) throws {
    guard let compressed = compressed else {
      throw PublicKeyError.invalidConfiguration
    }
    self.config = PublicKeyEth1Config(compressed: compressed)
    self.raw = publicKey
    self.chainCode = Data()
    self.depth = 0
    self.fingerprint = Data()
    self.index = index
    self.network = network
  }
}

extension PublicKeyEth1: Key {
  public func string() -> String? {
    return self.raw.toHexString()
  }
  
  public func extended() -> String? {
    guard let alphabet = self.network.alphabet else {
      return nil
    }
    var extendedKey = Data()
    
    extendedKey += Data(self.network.publicKeyPrefix.littleEndian.bytes)
    extendedKey += Data(self.depth.bigEndian.bytes)
    extendedKey += self.fingerprint
    extendedKey += Data(self.index.bigEndian.bytes)
    extendedKey += self.chainCode
    extendedKey += self.raw
    let checksum = extendedKey.sha256().sha256().prefix(4)
    extendedKey += checksum
    return extendedKey.encodeBase58(alphabet: alphabet)
  }
  
  public func data() -> Data {
    return self.raw
  }
  
  public func address() -> Address? {
    switch self.network {
    case .bitcoin, .litecoin:
      guard self.raw.count == PublicKeyEth1Constants.compressedKeySize else {
        return nil
      }
      guard let alphabet = self.network.alphabet else {
        return nil
      }
      let prefix = Data([self.network.publicKeyHash])
      let publicKey = self.raw
      let payload = publicKey.sha256().ripemd160()
      let checksum = (prefix + payload).sha256().sha256().prefix(4)
      let data = prefix + payload + checksum
      guard let stringAddress: String = data.encodeBase58(alphabet: alphabet) else {
        return nil
      }
      return Address(raw: stringAddress)
    default:
      guard self.raw.count == PublicKeyEth1Constants.decompressedKeySize else {
        return nil
      }
      let publicKey = self.raw
      let formattedData = (Data(hex: self.network.addressPrefix) + publicKey).dropFirst()
      let addressData = formattedData.sha3(.keccak256).suffix(20)
      guard let eip55 = addressData.eip55() else {
        return nil
      }
      return Address(address: eip55, prefix: self.network.addressPrefix)
    }
  }
}
