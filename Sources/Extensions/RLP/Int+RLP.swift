//
//  Int+RLP.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 4/25/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import BigInt

extension Int: RLP, RLPLength {
  func rlpEncode(offset: UInt8?) -> Data? {
    guard let offset = offset else {
        return BigInt(self).toRLP().rlpEncode(offset: offset)
    }
    return self.rlpLengthEncode(offset: offset)
  }
  
  func rlpLengthEncode(offset: UInt8) -> Data? {
    guard self >= 0 else {
      return nil
    }
    if self < 56 {
      return Data([UInt8(self) + offset])
    } else {
        return BigInt(self).toRLP().rlpLengthEncode(offset: offset)
    }
  }
}
