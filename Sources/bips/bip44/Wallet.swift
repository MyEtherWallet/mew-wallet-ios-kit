//
//  Wallet.swift
//  MEWwalletKitTests
//
//  Created by Mikhail Nikanorov on 4/17/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation

public enum WalletError: LocalizedError {
  case emptySeed
  case emptyPrivateKey
}

public final class Wallet {
  public static func generate(bitsOfEntropy: Int = 256, language: BIP39Wordlist = .english, network: Network = .ethereum) throws -> (BIP39, Wallet) {
    let bip39 = try BIP39(bitsOfEntropy: bitsOfEntropy, language: language)
    guard let seed = try bip39.seed() else {
      throw WalletError.emptySeed
    }
    let wallet = try Wallet(seed: seed, network: network)
    return (bip39, wallet)
  }
  
  public let privateKey: PrivateKey
  
  public init(seed: Data, network: Network = .ethereum) throws {
    self.privateKey = try PrivateKey(seed: seed, network: network)
  }
  
  public init(privateKey: PrivateKey) {
    self.privateKey = privateKey
  }
  
  public func derive(_ path: String) throws -> Wallet {
    let derivationPath = try path.derivationPath()
    
    guard let derivedPrivateKey = self.privateKey.derived(nodes: derivationPath) else {
      throw WalletError.emptyPrivateKey
    }
    return Wallet(privateKey: derivedPrivateKey)
  }
}
