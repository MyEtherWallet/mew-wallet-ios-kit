//
//  PrivateKey.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 12/04/20.
//  Copyright © 2020 MyEtherWallet Inc. All rights reserved.
//

import Foundation

public protocol PrivateKey: Key, BIP32 where BIPPK == Self {
  associatedtype PK
 
  init(seed: Data, network: Network) throws
  init(privateKey: Data, network: Network) throws
  func publicKey(compressed: Bool?) throws -> PK
  var hardenedEdge: Bool { get }
}
