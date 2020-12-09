//
//  Wallet.swift
//  MEWwalletKitTests
//
//  Created by Mikhail Nikanorov on 4/17/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation

public final class Wallet<PK: PrivateKey> {
  public static func generate(bitsOfEntropy: Int = 256, language: BIP39Wordlist = .english, network: Network = .ethereum) throws -> (BIP39, Wallet) {
    let bip39 = try BIP39(bitsOfEntropy: bitsOfEntropy, language: language)
    guard let seed = try bip39.seed() else {
      throw WalletError.emptySeed
    }
    let wallet = try Wallet(seed: seed, network: network)
    return (bip39, wallet)
  }
  
  public static func restore(mnemonic: [String], language: BIP39Wordlist = .english, network: Network = .ethereum) throws -> (BIP39, Wallet) {
    let bip39 = BIP39(mnemonic: mnemonic, language: language)
    return try self.restore(bip39: bip39, network: network)
  }
  
  public static func restore(bip39: BIP39, network: Network = .ethereum) throws -> (BIP39, Wallet) {
    guard let seed = try bip39.seed() else {
      throw WalletError.emptySeed
    }
    let wallet = try Wallet(seed: seed, network: network)
    return (bip39, wallet)
  }
  
  public let privateKey: PK
  
  public init(seed: Data, network: Network = .ethereum) throws {
    self.privateKey = try PK(seed: seed, network: network)
  }
  
  public init(privateKey: PK) {
    self.privateKey = privateKey
  }
  
  public func derive(_ path: String, index: Int? = nil) throws -> Wallet {
    var derivationPath = try path.derivationPath(checkHardenedEdge: self.privateKey.hardenedEdge)
    if let index = index {
      derivationPath.append(.nonHardened(UInt32(index)))
    }
    
    let derivedPrivateKey = try self.privateKey.derived(nodes: derivationPath)
    return Wallet(privateKey: derivedPrivateKey)
  }
  
  public func derive(_ network: Network, index: UInt32? = nil) throws -> Wallet {
    let path = network.path(index: index)
    let derivationPath = try path.derivationPath(checkHardenedEdge: self.privateKey.hardenedEdge)
    let derivedPrivateKey = try self.privateKey.derived(nodes: derivationPath)
    return Wallet(privateKey: derivedPrivateKey)
  }
}
