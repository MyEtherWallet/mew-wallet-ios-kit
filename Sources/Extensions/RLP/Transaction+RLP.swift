//
//  Transaction+RLP.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 4/25/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import BigInt

extension Transaction: RLP {
  func rlpEncode(offset: UInt8? = nil) -> Data? {
    return self.rlpData().rlpEncode()
  }
}
