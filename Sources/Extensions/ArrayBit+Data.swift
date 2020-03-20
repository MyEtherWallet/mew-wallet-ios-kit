//
//  ArrayBit+Data.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 4/16/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import CryptoSwift

extension Array where Element == Bit {
  var bytes: [UInt8] {
    var bytes: [UInt8] = []
    
    var leftItems = self.count
    
    var byte: UInt8 = 0
    var index = 0
    var paddingIndex = 0
    
    while leftItems % 8 != 0 {
      byte += UInt8(self[paddingIndex].rawValue)
      paddingIndex += 1
      leftItems -= 1
      if leftItems % 8 != 0 {
        byte <<= 1
      }
    }
    
    if byte != 0 {
      bytes.append(byte)
      byte = 0
    }
    
    while leftItems > 0 {
      byte += UInt8(self[index + paddingIndex].rawValue)
      leftItems -= 1
      index += 1
      if index % 8 == 0 {
        bytes.append(byte)
        byte = 0
      } else {
        byte <<= 1
      }
    }
    
    if byte != 0 {
      bytes.append(byte)
    }
    
    return bytes
  }
  
  func data() -> Data {
    return Data(self.bytes)
  }
  
  func uint64() -> UInt64? {
    let bytes = self.bytes
    guard bytes.count <= 8 else {
      return nil
    }
    var uint: UInt64 = 0
    for byte in bytes {
      uint <<= 8
      uint += UInt64(byte)
    }
    return uint
  }
}
