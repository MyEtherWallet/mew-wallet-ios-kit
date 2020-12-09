//
//  BIP32.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 12/04/20.
//  Copyright © 2020 MyEtherWallet Inc. All rights reserved.
//

import Foundation

public protocol BIP32 {
  associatedtype BIPPK
  func derived(nodes: [DerivationNode]) throws -> BIPPK
}
