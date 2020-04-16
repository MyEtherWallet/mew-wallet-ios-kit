//
//  DataZeroTests.swift
//  MEWwalletKitTests
//
//  Created by Mikhail Nikanorov on 4/18/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MEWwalletKit

class DataZeroTests: QuickSpec {
  override func spec() {
    describe("Data+Zero tests") {
      it("Should clear memory as expected") {
        var data1 = Data([0x00])
        var data2 = Data([0xFF])
        var data3 = Data([0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF])
        var data4 = Data([0x01, 0x23, 0x45, 0x67, 0x89, 0xAB, 0xCD, 0xEF])
        
        data1.zero()
        data2.zero()
        data3.zero()
        data4.zero()
        
        expect(data1).to(equal(Data([0x00])))
        expect(data2).to(equal(Data([0x00])))
        expect(data3).to(equal(Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])))
        expect(data4).to(equal(Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])))
      }
    }
  }
}
