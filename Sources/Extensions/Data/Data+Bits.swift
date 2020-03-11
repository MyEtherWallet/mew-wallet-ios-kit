//
//  Data+Bits.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 4/15/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import CryptoSwift

extension Data {
  init(bits: [Bit]) {
    self.init()
  }
  
  func bits(position: Int, length: Int) -> UInt64? {
    guard position >= 0, length >= 1, position <= position + length - 1 else {
      return nil
    }
    return self.bits(position ... position + length - 1)
  }
  
  func bits(_ range: ClosedRange<Int>) -> UInt64? {
    let reader = BitReader(data: self)
    return reader.bits(range: range)
  }
  
  func bits(position: Int, length: Int) -> [Bit]? {
    guard position >= 0, length >= 1, position <= position + length - 1 else {
      return nil
    }
    return self.bits(position ... position + length - 1)
  }

  func bits(_ range: ClosedRange<Int>) -> [Bit]? {
    let bits: [Bit] = self.bytes.flatMap { $0.bits() }
    guard range.lowerBound >= 0, range.upperBound >= 0, range.lowerBound < bits.count, range.upperBound < bits.count else {
      return nil
    }
    return Array(bits[range])
  }
}

// MARK: - Private

private struct BitReader {
  private let data: [UInt8]
  
  init (data: Data) {
    self.data = data.bytes
  }
  
  func length() -> Int {
    return 8 * self.data.count
  }
  
  func bits(range: ClosedRange<Int>) -> UInt64? {
    guard range.lowerBound >= 0, range.upperBound < self.length() else {
      return nil
    }
    
    var byteIdx = 0
    var remainingBits = range.count
    
    var result: UInt64 = 0
    
    // Read remaining bits from first byte:
    if range.lowerBound > 0 {
      byteIdx = range.lowerBound / 8
      let startByteRange = (range.lowerBound % 8) ... min(range.lowerBound % 8 + range.count, 7)
      result += UInt64(self.readByte(byte: self.data[byteIdx], range: startByteRange))
      remainingBits -= startByteRange.count
      if remainingBits > 0 {
        result <<= remainingBits
        byteIdx += 1
      }
    }
    
    // Read entire bytes
    while remainingBits >= 8 {
      remainingBits -= 8
      result += UInt64(self.readByte(byte: self.data[byteIdx], range: 0 ... 7)) << remainingBits
      byteIdx += 1
    }
    // Read remaining bits from last byte
    
    if remainingBits > 0 {
      let endByteRange = 0 ... remainingBits - 1
      result += UInt64(self.readByte(byte: self.data[byteIdx], range: endByteRange))
      remainingBits -= endByteRange.count
    }
    
    return result
  }
  
  // MARK: - Private
  
  private func readByte(byte: UInt8, range: ClosedRange<Int>) -> UInt8 {
    guard range.lowerBound < 8, range.upperBound < 8 else {
      return 0
    }
    
    var bits = byte
    bits <<= range.lowerBound
    bits >>= range.lowerBound + (7 - range.upperBound)
    return bits
  }
}
