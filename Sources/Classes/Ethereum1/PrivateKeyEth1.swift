//
//  PrivateKeyEth1.swift
//  MEWwalletKitTests
//
//  Created by Mikhail Nikanorov on 4/17/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import CryptoSwift
import MEW_wallet_iOS_secp256k1_package

private let HMACKeyData: [UInt8] = [0x42, 0x69, 0x74, 0x63, 0x6F, 0x69, 0x6E, 0x20, 0x73, 0x65, 0x65, 0x64] //"Bitcoin seed"

public struct PrivateKeyEth1 {
  private let raw: Data
  private let chainCode: Data
  private let depth: UInt8
  private let fingerprint: Data
  private let index: UInt32
  public let network: Network
  
  private init(privateKey: Data, chainCode: Data, depth: UInt8, fingerprint: Data, index: UInt32, network: Network) {
    self.raw = privateKey
    self.chainCode = chainCode
    self.depth = depth
    self.fingerprint = fingerprint
    self.index = index
    self.network = network
  }
}

// MARK: - PrivateKey

extension PrivateKeyEth1: PrivateKey {
  public var hardenedEdge: Bool {
    return true
  }
  
  public init(seed: Data, network: Network) throws {
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
  
  public init(privateKey: Data, network: Network = .none) {
    self.raw = privateKey
    self.chainCode = Data()
    self.depth = 0
    self.fingerprint = Data([0x00, 0x00, 0x00, 0x00])
    self.index = 0
    self.network = network
  }
  
  public func publicKey(compressed: Bool? = nil) throws -> PublicKeyEth1 {
    let compressed = compressed ?? self.network.publicKeyCompressed
    let publicKey = try PublicKeyEth1(privateKey: self.raw, compressed: compressed, chainCode: self.chainCode, depth: self.depth,
                                      fingerprint: self.fingerprint, index: self.index, network: self.network)
    return publicKey
  }
}

// MARK: - Key

extension PrivateKeyEth1: Key {
  public func string() -> String? {
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
  
  public func extended() -> String? {
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
  
  public func data() -> Data {
    return self.raw
  }
  
  public func address() -> Address? {
    return try? self.publicKey().address()
  }
}

// MARK: - BIP32

extension PrivateKeyEth1: BIP32 {
  public func derived(nodes: [DerivationNode]) throws -> PrivateKeyEth1 {
    if case .none = self.network {
      return self
    }
    guard nodes.count > 0 else {
      return self
    }
    guard let node = nodes.first else {
      return self
    }
    
    let derivingIndex: UInt32
    let derivedPrivateKeyData: Data
    let derivedChainCode: Data
    
    let publicKeyData = try self.publicKey(compressed: true).data()
    
    var data = Data()
    if case .hardened = node {
      data += Data([0x00])
      data += self.raw
    } else {
      data += publicKeyData
    }
    
    derivingIndex = CFSwapInt32BigToHost(node.index())
    data += Data(derivingIndex.bigEndian.bytes)
    
    let digest = try Data(HMAC(key: self.chainCode.bytes, variant: .sha512).authenticate(data.bytes))
    
    let factor = MEWBigInt<UInt8>(digest[0 ..< 32].bytes)
    guard let curveOrder = MEWBigInt<UInt8>("FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141", radix: 16) else {
      throw PrivateKeyError.invalidData
    }

    let rawKey = MEWBigInt<UInt8>(self.raw)
    
    var reversedRawKeyData = rawKey.reversedData
    reversedRawKeyData.setLength(32, appendFromLeft: true)
    
    var reversedFactorData = factor.reversedData
    reversedFactorData.setLength(32, appendFromLeft: true)
    
    //swiftlint:disable:next identifier_name
    let bn = MEWBigInt<UInt8>(reversedRawKeyData) + MEWBigInt<UInt8>(reversedFactorData)
    let calculatedKey = (bn % curveOrder)
    
    var derivedPrivateKeyDataCandidate = calculatedKey.reversedData
    derivedPrivateKeyDataCandidate.setLength(32, appendFromLeft: true)
    derivedPrivateKeyData = derivedPrivateKeyDataCandidate
    derivedChainCode = Data(digest[32 ..< 64])
    
    let fingerprint = Data(publicKeyData.ripemd160().prefix(4))
    let derivedPrivateKey = PrivateKeyEth1(privateKey: derivedPrivateKeyData,
                                       chainCode: derivedChainCode,
                                       depth: self.depth + 1,
                                       fingerprint: fingerprint,
                                       index: derivingIndex,
                                       network: self.network)
    if nodes.count > 1 {
      return try derivedPrivateKey.derived(nodes: Array(nodes[1 ..< nodes.count]))
    }
    
    return derivedPrivateKey
  }
}
