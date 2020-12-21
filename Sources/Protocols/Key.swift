//
//  Key.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 4/19/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation

public protocol Key {
  var network: Network { get }
  func string() -> String?
  func extended() -> String?
  func data() -> Data
  func address() -> Address?
}
