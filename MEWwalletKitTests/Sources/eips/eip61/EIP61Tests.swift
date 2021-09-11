//
//  EIP61Tests.swift
//  MEWwalletKitTests
//
//  Created by Mikhail Nikanorov on 9/11/21.
//  Copyright © 2021 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import Quick
import Nimble
import BigInt
@testable import MEWwalletKit

class EIP61Tests: QuickSpec {
  lazy var testVectors: [String] = {
    return [
      "ethereum:0xeeee00000000000000000000000000000000eeee?gas=100000&data=0xa9059cbb00000000000000000000000000000000000000000000000000000000deadbeef0000000000000000000000000000000000000000000000000000000000000005",
      "ethereum:0xeeee00000000000000000000000000000000eeee?gas=100000&function=transfer(address 0xeeee00000000000000000000000000000000eeee, uint 5)",
      "ethereum:0xeeee00000000000000000000000000000000eeee",
      "ethereum:0xeeee00000000000000000000000000000000eeee=100000&function=transfer(address 0xeeee00000000000000000000000000000000eeee, uint 5)",
      "ethereum:0xdeadbeef",
    ]
  }()
    
  override func spec() {
    describe("EIP-61 parsing") {
      it("should parse link from test vector 1 of (\(self.testVectors.count)") {
        let code = EIP61Code(self.testVectors[0])
        expect(code).toNot(beNil())
        expect(code!.targetAddress).toNot(beNil())
        expect(code!.targetAddress).to(equal(Address(ethereumAddress: "0xeeee00000000000000000000000000000000eeee")))
        expect(code!.value).to(beNil())
        expect(code!.gasLimit).to(equal(BigInt("100000")))
        expect(code!.data).toNot(beNil())
        expect(code!.data).to(equal(Data(hex: "0xa9059cbb00000000000000000000000000000000000000000000000000000000deadbeef0000000000000000000000000000000000000000000000000000000000000005")))
        expect(code!.functionName).to(beNil())
        expect(code!.function).to(beNil())
        expect(code!.parameters).to(beEmpty())
      }
      it("should parse link from test vector 2 of (\(self.testVectors.count)") {
        let code = EIP61Code(self.testVectors[1])
        expect(code).toNot(beNil())
        expect(code!.targetAddress).toNot(beNil())
        expect(code!.targetAddress).to(equal(Address(ethereumAddress: "0xeeee00000000000000000000000000000000eeee")))
        expect(code!.value).to(beNil())
        expect(code!.gasLimit).to(equal(BigInt("100000")))
        expect(code!.data).to(beNil())
        expect(code!.functionName).to(equal("transfer"))
        expect(code!.function).to(equal(.init(name: "transfer",
                                              inputs: [
                                                .init(name: "0", type: .address),
                                                .init(name: "1", type: .uint(bits: 256))
                                              ],
                                              outputs: [],
                                              constant: false,
                                              payable: false)))

        expect(code!.parameters).to(equal([
          EIP61Code.Parameter(type: .address, value: Address(ethereumAddress: "0xeeee00000000000000000000000000000000eeee") as AnyObject),
          EIP61Code.Parameter(type: .uint(bits: 256), value: BigUInt("5") as AnyObject)
        ]))
      }
      it("should parse link from test vector 3 of (\(self.testVectors.count)") {
        let code = EIP61Code(self.testVectors[2])
        expect(code).toNot(beNil())
        expect(code!.targetAddress).toNot(beNil())
        expect(code!.targetAddress).to(equal(Address(ethereumAddress: "0xeeee00000000000000000000000000000000eeee")))
        expect(code!.value).to(beNil())
        expect(code!.gasLimit).to(beNil())
        expect(code!.data).to(beNil())
        expect(code!.functionName).to(beNil())
        expect(code!.function).to(beNil())
        expect(code!.parameters).to(beEmpty())
      }
      it("should parse link from test vector 4 of (\(self.testVectors.count)") {
        let code = EIP61Code(self.testVectors[3])
        expect(code).toNot(beNil())
      }
      it("should parse link from test vector 5 of (\(self.testVectors.count)") {
        let code = EIP61Code(self.testVectors[4])
        expect(code).to(beNil())
      }
    }
  }
}
