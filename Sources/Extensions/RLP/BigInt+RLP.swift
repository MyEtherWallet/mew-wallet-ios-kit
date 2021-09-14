//
//  BigInt+RLP.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 4/25/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import BigInt

private let rlpLengthMax = BigInt(1) << 256

extension RLPBigInt: RLP, RLPLength {
  func rlpEncode(offset: UInt8?) -> Data? {
    guard let offset = offset else {
        return self.data.rlpEncode()
    }
    
    return self.rlpLengthEncode(offset: offset)
  }
  
  func rlpLengthEncode(offset: UInt8) -> Data? {
    guard self.value < rlpLengthMax else {
      return nil
    }
    return BigInt(self.dataLength + Int(offset) + 55).data + self.data
  }
}

extension BigInt {
  var data: Data {
      return toTwosComplement()
  }
  
  // takes all data as magnitude without dropping first bytes
  init(data: Data) {
      self.init()
      
      self.sign = .plus
      self.magnitude = BigUInt(data)
  }
  
  init(_ bytes: [UInt8]) {
      self.init()
      
      self.sign = .plus
      self.magnitude = BigUInt(Data(bytes))
  }
}
