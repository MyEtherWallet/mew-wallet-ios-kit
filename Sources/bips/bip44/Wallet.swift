//
//  Wallet.swift
//  MEWwalletKitTests
//
//  Created by Mikhail Nikanorov on 4/17/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation

public final class Wallet {
  let masterKey: PrivateKey
  
  init(seed: Data, network: Network = .ethereum) throws {
    self.masterKey = try PrivateKey(seed: seed, network: network)
  }
  
  init(privateKey: PrivateKey) {
    self.masterKey = privateKey
  }
}
