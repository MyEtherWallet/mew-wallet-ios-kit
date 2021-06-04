//
//  ArrayBitDataTests.swift
//  MEWwalletKitTests
//
//  Created by Mikhail Nikanorov on 4/16/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import Quick
import Nimble
import CryptoSwift
@testable import MEWwalletKit

class ArrayBitDataTests: QuickSpec {
  override func spec() {
    describe("ArrayBit+Data tests") {
      let bitsLong: [Bit] = [.zero, .one, .zero, .one, .zero, .one, .zero, .one,
                             .one, .one, .one, .one, .one, .one, .one, .one,
                             .one, .zero, .one, .zero, .one, .zero, .one, .zero] // 0b01010101_11111111_10101010
      let bitsShort: [Bit] = [.one, .one, .zero, .one] // 0b00001101
      
      it("Should return correct bytes") {
        let bytesLong: [UInt8] = bitsLong.bytes
        expect(bytesLong[0]).to(equal(0b01010101))
        expect(bytesLong[1]).to(equal(0b11111111))
        expect(bytesLong[2]).to(equal(0b10101010))
        
        let bytesShort: [UInt8] = bitsShort.bytes
        expect(bytesShort[0]).to(equal(0b00001101))
      }
      it("Should return correct data") {
        let dataLong = bitsLong.data()
        expect(dataLong).to(equal(Data([0b01010101, 0b11111111, 0b10101010])))
        
        let dataShort = bitsShort.data()
        expect(dataShort).to(equal(Data([0b00001101])))
      }
      it("Should return correct uint64 value") {
        let bits64: [Bit] = [.one, .one, .one, .one, .zero, .zero, .zero, .zero,
                             .zero, .zero, .zero, .zero, .one, .one, .one, .one,
                             .one, .one, .one, .one, .zero, .zero, .zero, .zero,
                             .zero, .zero, .zero, .zero, .one, .one, .one, .one,
                             .one, .one, .one, .one, .zero, .zero, .zero, .zero,
                             .zero, .zero, .zero, .zero, .one, .one, .one, .one,
                             .one, .one, .one, .one, .zero, .zero, .zero, .zero,
                             .zero, .zero, .zero, .zero, .one, .one, .one, .one] // 64bit-value
        let value64 = bits64.uint64()
        let checkValue: UInt64 = 0b11110000_00001111_11110000_00001111_11110000_00001111_11110000_00001111
        expect(value64).to(equal(checkValue))
      }
    }
  }
}
