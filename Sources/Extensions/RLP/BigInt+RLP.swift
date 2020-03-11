//
//  BigInt+RLP.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 4/25/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation

private let rlpLengthMax = BigInt<UInt8>(1) << 256

extension BigInt: RLP, RLPLength where Word == UInt8 {
  
  func rlpEncode(offset: UInt8?) -> Data? {
    guard let offset = offset else {
      return Data(self._data.reversed()).rlpEncode()
    }
    return self.rlpLengthEncode(offset: offset)
  }
  
  func rlpLengthEncode(offset: UInt8) -> Data? {
    guard self < rlpLengthMax else {
      return nil
    }
    return Data(BigInt<UInt8>(self._data.count + Int(offset) + 55)._data.reversed()) + Data(self._data.reversed())
  }
}
