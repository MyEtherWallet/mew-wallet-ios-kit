//
//  DataBitsTests.swift
//  MEWwalletKitTests
//
//  Created by Mikhail Nikanorov on 4/15/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import Quick
import Nimble
import CryptoSwift
@testable import MEWwalletKit

class DataBitsTests: QuickSpec {
  override func spec() {
    describe("Data+Bits tests") {
      let data = Data([0b00001111, 0b00110011, 0b11001100]) // length == 3 bytes/24 bits
      it("Should return nil if incorrect size and offset are used") {
        let overflowRangeUInt: UInt64? = data.bits(position: 250, length: 20)
        let overflowRangeBits: [Bit]? = data.bits(position: 250, length: 20)
        expect(overflowRangeUInt).to(beNil())
        expect(overflowRangeBits).to(beNil())
        
        let incorrectStartingBitUInt: UInt64? = data.bits(position: -1, length: 10)
        let incorrectStartingBitBits: [Bit]? = data.bits(position: -1, length: 10)
        expect(incorrectStartingBitUInt).to(beNil())
        expect(incorrectStartingBitBits).to(beNil())
        
        let incorrectLengthUInt: UInt64? = data.bits(position: 0, length: -1)
        let incorrectLengthBits: [Bit]? = data.bits(position: 0, length: -1)
        expect(incorrectLengthUInt).to(beNil())
        expect(incorrectLengthBits).to(beNil())
      }
      it("Should return correct value for provided size and offset") {
        let bitsUInt0_4: UInt64? = data.bits(position: 0, length: 4)
        let bitsUInt0_8: UInt64? = data.bits(position: 0, length: 8)
        let bitsUInt0_12: UInt64? = data.bits(position: 0, length: 12)
        let bitsUInt11_11: UInt64? = data.bits(position: 11, length: 11)
        let bitsUInt0_24: UInt64? = data.bits(position: 0, length: 24)
        let bitsUInt16_8: UInt64? = data.bits(position: 16, length: 8)
        
        let bitsBits0_4: [Bit]? = data.bits(position: 0, length: 4)
        let bitsBits0_8: [Bit]? = data.bits(position: 0, length: 8)
        let bitsBits0_12: [Bit]? = data.bits(position: 0, length: 12)
        let bitsBits11_11: [Bit]? = data.bits(position: 11, length: 11)
        let bitsBits0_24: [Bit]? = data.bits(position: 0, length: 24)
        let bitsBits16_8: [Bit]? = data.bits(position: 16, length: 8)
        
        expect(bitsUInt0_4).to(equal(0b0000))
        expect(bitsUInt0_8).to(equal(0b00001111))
        expect(bitsUInt0_12).to(equal(0b00001111_0011))
        expect(bitsUInt11_11).to(equal(0b10011_110011))
        expect(bitsUInt0_24).to(equal(0b00001111_00110011_11001100))
        expect(bitsUInt16_8).to(equal(0b11001100))
        
        expect(bitsBits0_4).to(equal([.zero, .zero, .zero, .zero]))
        expect(bitsBits0_8).to(equal([.zero, .zero, .zero, .zero, .one, .one, .one, .one]))
        expect(bitsBits0_12).to(equal([.zero, .zero, .zero, .zero, .one, .one, .one, .one, .zero, .zero, .one, .one]))
        expect(bitsBits11_11).to(equal([.one, .zero, .zero, .one, .one, .one, .one, .zero, .zero, .one, .one]))
        expect(bitsBits0_24).to(equal([.zero, .zero, .zero, .zero, .one, .one, .one, .one,
                                       .zero, .zero, .one, .one, .zero, .zero, .one, .one,
                                       .one, .one, .zero, .zero, .one, .one, .zero, .zero]))
        expect(bitsBits16_8).to(equal([.one, .one, .zero, .zero, .one, .one, .zero, .zero]))
      }
    }
  }
}
