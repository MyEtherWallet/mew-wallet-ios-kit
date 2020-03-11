//
//  Data+RLP.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 4/25/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation

extension Data: RLP {
  func rlpEncode(offset: UInt8? = nil) -> Data? {
    if self.count == 1 && self.bytes[0] < 0x80 {
      return self
    }
    
    guard let length = self.count.rlpLengthEncode(offset: 0x80) else {
      return nil
    }
    return length + self
  }
}
