//
//  String+RLP.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 4/25/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation

extension String: RLP {
  func rlpEncode(offset: UInt8? = nil) -> Data? {
    if self.isHex() {
      return Data(hex: self).rlpEncode()
    } else {
      return self.data(using: .utf8)?.rlpEncode()
    }
  }
}
