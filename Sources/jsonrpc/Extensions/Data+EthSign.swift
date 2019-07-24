//
//  Data+EthSign.swift
//  MEWwalletKitTests
//
//  Created by Mikhail Nikanorov on 7/24/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation

private let ethSignPrefix = "\u{19}Ethereum Signed Message:\n"

extension Data {
  func hashPersonalMessage() -> Data? {
    var prefix = ethSignPrefix
    prefix += String(self.count)
    guard let prefixData = prefix.data(using: .ascii) else {
      return nil
    }
    let data = prefixData + self
    let hash = data.sha3(.keccak256)
    return hash
  }
}
