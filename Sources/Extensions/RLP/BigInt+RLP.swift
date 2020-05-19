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
      return self.reversedData.rlpEncode()
    }
    return self.rlpLengthEncode(offset: offset)
  }
  
  func rlpLengthEncode(offset: UInt8) -> Data? {
    guard self < rlpLengthMax else {
      return nil
    }
    return BigInt<UInt8>(self.dataLength + Int(offset) + 55).reversedData + self.reversedData
  }
}
