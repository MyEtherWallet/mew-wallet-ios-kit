//
//  PrivateKey.swift
//  MEWwalletKitTests
//
//  Created by Mikhail Nikanorov on 4/17/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import CryptoSwift
import libsecp256k1

enum PrivateKeyError: Error {
  case invalidData
}

private let HMACKeyData: [UInt8] = [0x42, 0x69, 0x74, 0x63, 0x6F, 0x69, 0x6E, 0x20, 0x73, 0x65, 0x65, 0x64] //"Bitcoin seed"

public struct PrivateKey: Key {
  private let raw: Data
  private let chainCode: Data
  private let depth: UInt8
  private let fingerprint: Data
  private let index: UInt32
  private let network: Network
  
  init(seed: Data, network: Network) throws {
    let output = try Data(HMAC(key: HMACKeyData, variant: .sha512).authenticate(seed.bytes))
    guard output.count == 64 else {
      throw PrivateKeyError.invalidData
    }
    self.raw = output[0 ..< 32]
    self.chainCode = output[32 ..< 64]
    self.depth = 0
    self.fingerprint = Data([0x00, 0x00, 0x00, 0x00])
    self.index = 0
    self.network = network
  }
  
  init(privateKey: Data, network: Network) {
    self.raw = privateKey
    self.chainCode = Data()
    self.depth = 0
    self.fingerprint = Data([0x00, 0x00, 0x00, 0x00])
    self.index = 0
    self.network = network
  }
  
  private init(privateKey: Data, chainCode: Data, depth: UInt8, fingerprint: Data, index: UInt32, network: Network) {
    self.raw = privateKey
    self.chainCode = chainCode
    self.depth = depth
    self.fingerprint = fingerprint
    self.index = index
    self.network = network
  }
  
  func derived(nodes: [DerivationNode]) -> PrivateKey? {
    guard nodes.count > 0 else {
      return self
    }
    guard let node = nodes.first else {
      return self
    }
    
    let derivingIndex: UInt32
    let derivedPrivateKeyData: Data
    let derivedChainCode: Data
    
    guard let publicKeyData = self.publicKey(compressed: true)?.data() else {
      return nil
    }
    
    var data = Data()
    if case .hardened = node {
      data += Data([0x00])
      data += self.raw
    } else {
      data += publicKeyData
    }
    
    derivingIndex = CFSwapInt32BigToHost(node.index())
    data += Data(derivingIndex.bigEndian.bytes)
    
    let digest: Data

    do {
      digest = try Data(HMAC(key: self.chainCode.bytes, variant: .sha512).authenticate(data.bytes))
    } catch {
      return nil
    }
    
    let factor = BigInt<UInt8>(digest[0 ..< 32].bytes)
    guard let curveOrder = BigInt<UInt8>("FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141", radix: 16) else {
      return nil
    }

    let rawKey = BigInt<UInt8>(self.raw)
    
    let calculatedKey = ((BigInt<UInt8>(factor._data.reversed()) +
                          BigInt<UInt8>(rawKey._data.reversed())) % curveOrder)

    derivedPrivateKeyData = Data(calculatedKey._data.reversed())
    derivedChainCode = Data(digest[32 ..< 64])
    
    let fingerprint = Data(publicKeyData.ripemd160().prefix(4))
    let derivedPrivateKey = PrivateKey(privateKey: derivedPrivateKeyData,
                                       chainCode: derivedChainCode,
                                       depth: self.depth + 1,
                                       fingerprint: fingerprint,
                                       index: derivingIndex,
                                       network: self.network)
    if nodes.count > 1 {
      return derivedPrivateKey.derived(nodes: Array(nodes[1 ..< nodes.count]))
    }
    
    return derivedPrivateKey
  }
  
  private func derive(node: DerivationNode) -> PrivateKey? {
    return nil
  }
  
  func publicKey(compressed: Bool? = nil) -> PublicKey? {
    let compressed = compressed ?? self.network.publicKeyCompressed
    do {
      let publicKey = try PublicKey(privateKey: self.raw, compressed: compressed, chainCode: self.chainCode, depth: self.depth,
                                    fingerprint: self.fingerprint, index: self.index, network: self.network)
      return publicKey
    } catch {
      return nil
    }
  }
  
  // MARK: - Key
  
  func string() -> String? {
    guard let wifPrefix = self.network.wifPrefix, let alphabet = self.network.alphabet else {
      return self.raw.toHexString()
    }
    var data = Data()
    data += Data([wifPrefix])
    data += self.raw
    data += Data([0x01])
    data += data.sha256().sha256().prefix(4)
    return data.encodeBase58(alphabet: alphabet)
  }
  
  func extended() -> String? {
    guard let alphabet = self.network.alphabet else {
      return nil
    }
    var extendedKey = Data()
    extendedKey += Data(self.network.privateKeyPrefix.littleEndian.bytes)
    extendedKey += Data(self.depth.bigEndian.bytes)
    extendedKey += self.fingerprint
    extendedKey += Data(self.index.bigEndian.bytes)
    extendedKey += self.chainCode
    extendedKey += Data([0x00])
    extendedKey += self.raw
    let checksum = extendedKey.sha256().sha256().prefix(4)
    extendedKey += checksum
    return extendedKey.encodeBase58(alphabet: alphabet)
  }
  
  func data() -> Data {
    return self.raw
  }
  
  public func address() -> Address? {
    return self.publicKey()?.address()
  }
}
