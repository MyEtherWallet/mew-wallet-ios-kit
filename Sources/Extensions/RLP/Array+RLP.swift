//
//  Array+RLP.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 4/25/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation

extension Array: RLP where Element == RLP {
  func rlpEncode(offset: UInt8? = nil) -> Data? {
    var data = Data()
    for item in self {
      guard let encoded = item.rlpEncode(offset: nil) else {
        return nil
      }
      data += encoded
    }
    guard let length = data.count.rlpLengthEncode(offset: 0xc0) else {
      return nil
    }
    return length + data
  }
}
