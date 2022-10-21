//
//  SecretKeyEth2.swift
//  MEWwalletKitTests
//
//  Created by Mikhail Nikanorov on 12/4/20.
//  Copyright © 2020 MyEtherWallet Inc. All rights reserved.
//

#if !os(Linux)

import Foundation
import bls_framework

private let SECRET_KEY_LENGHT = 32

public struct SecretKeyEth2 {
  private let raw: Data
  private let index: UInt32
  public let network: Network
  
  public init(privateKey: Data, index: UInt32, network: Network) {
    self.raw = privateKey
    self.index = index
    self.network = network
  }
}

// MARK: - PrivateKey

extension SecretKeyEth2: PrivateKey {
  public var hardenedEdge: Bool {
    return false
  }
  
  public init(seed: Data, network: Network) throws {
    self.raw = try seed.deriveRootSK()
    self.index = 0
    self.network = network
  }
  
  public init(privateKey: Data, network: Network = .none) throws {
    guard privateKey.count == SECRET_KEY_LENGHT else {
      throw PrivateKeyError.invalidData
    }
    self.raw = privateKey
    self.index = 0
    self.network = network
  }
  
  public func publicKey(compressed: Bool? = nil) -> PublicKeyEth2? {
    var raw = self.raw
    guard var blsPublicKey = try? raw.blsPublicKey() else {
      return nil
    }
    let data = blsPublicKey.serialize()
    return try? PublicKeyEth2(publicKey: data, compressed: compressed, index: self.index, network: self.network)
  }
}

// MARK: - Key

extension SecretKeyEth2: Key {
  public func string() -> String? {
    return self.raw.toHexString()
  }
  
  public func extended() -> String? {
    return nil
  }
  
  public func data() -> Data {
    return self.raw
  }
  
  public func address() -> Address? {
    return self.publicKey()?.address()
  }
}

// MARK: - BIP32

extension SecretKeyEth2: BIP32 {
  public func derived(nodes: [DerivationNode]) throws -> SecretKeyEth2 {
    if case .none = self.network {
      return self
    }
    var nodes = nodes
    guard nodes.count > 0 else {
      return self
    }
    let node = nodes.removeFirst()
    
    let derivedSKRaw = try self.raw.deriveChildSK(index: node.index())
    let derivedSK = SecretKeyEth2(privateKey: derivedSKRaw,
                                  index: node.index(),
                                  network: self.network)
    if nodes.count > 0 {
      return try derivedSK.derived(nodes: nodes)
    }
    return derivedSK
  }
}
#endif
