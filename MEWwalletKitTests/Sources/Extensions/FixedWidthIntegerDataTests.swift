//
//  FixedWidthIntegerDataTests.swift
//  MEWwalletKitTests
//
//  Created by Mikhail Nikanorov on 4/16/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Quick
import Nimble
@testable import MEWwalletKit

class FixedWidthIntegerDataTests: QuickSpec {
  override func spec() {
    describe("Int+Data tests") {
      it("Should return correct bytes count") {
        let valueInt8: Int8 = 0
        let valueInt16: Int16 = 0
        let valueInt32: Int32 = 0
        let valueInt64: Int64 = 0
        
        let bytesInt8 = valueInt8.bytes
        let bytesInt16 = valueInt16.bytes
        let bytesInt32 = valueInt32.bytes
        let bytesInt64 = valueInt64.bytes
        
        expect(bytesInt8).to(haveCount(1))
        expect(bytesInt16).to(haveCount(2))
        expect(bytesInt32).to(haveCount(4))
        expect(bytesInt64).to(haveCount(8))
      }
      
      it("Should return correct bytes value") {
        let value0: Int16 = 0b00000000_000000000
        let value2080: Int16 = 0b00001000_00100000
        let value65280: UInt16 = 0b11111111_00000000
        
        let bytes0 = value0.bytes
        let bytes2080 = value2080.bytes
        let bytes65280 = value65280.bytes
        
        expect(bytes0[0]).to(equal(0b00000000))
        expect(bytes0[1]).to(equal(0b00000000))
        
        expect(bytes2080[0]).to(equal(0b00001000))
        expect(bytes2080[1]).to(equal(0b00100000))
        
        expect(bytes65280[0]).to(equal(0b11111111))
        expect(bytes65280[1]).to(equal(0b00000000))
      }
    }
  }
}
