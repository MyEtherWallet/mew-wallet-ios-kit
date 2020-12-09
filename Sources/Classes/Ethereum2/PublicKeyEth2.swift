//
//  PublicKeyEth1.swift
//  MEWwalletKitTests
//
//  Created by Mikhail Nikanorov on 12/4/20.
//  Copyright © 2020 MyEtherWallet Inc. All rights reserved.
//

import Foundation

public struct PublicKeyEth2: PublicKey {
  private let raw: Data
  private let index: UInt32
  private let network: Network

  init(publicKey: Data, compressed: Bool?, index: UInt32, network: Network) throws {
    self.raw = publicKey
    self.index = index
    self.network = network
  }
}

extension PublicKeyEth2: Key {
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
    return nil
  }
}
