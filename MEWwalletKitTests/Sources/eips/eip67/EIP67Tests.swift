//
//  EIP67Tests.swift
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

class EIP67Tests: QuickSpec {
  lazy var testVectors: [String] = {
    return [
      "ethereum:0xcccc00000000000000000000000000000000cccc?gas=100000&data=0xa9059cbb00000000000000000000000000000000000000000000000000000000deadbeef0000000000000000000000000000000000000000000000000000000000000005",
      "ethereum:0xcccc00000000000000000000000000000000cccc?gas=100000&function=transfer(address 0xeeee00000000000000000000000000000000eeee, uint 5)",
      "ethereum:0xeeee00000000000000000000000000000000eeee",
      "ethereum:0xcccc00000000000000000000000000000000cccc=100000&function=transfer(address 0xeeee00000000000000000000000000000000eeee, uint 5)",
      "ethereum:0xdeadbeef",
    ]
  }()
    
  override func spec() {
    describe("EIP-67 parsing") {
      it("should parse link from test vector 1 of (\(self.testVectors.count)") {
        let code = EIP67Code(self.testVectors[0])
        expect(code).toNot(beNil())
        expect(code!.targetAddress).toNot(beNil())
        expect(code!.targetAddress).to(equal(Address(ethereumAddress: "0xcccc00000000000000000000000000000000cccc")))
        expect(code!.recipientAddress).toNot(beNil())
        expect(code!.recipientAddress).to(equal(Address(ethereumAddress: "0x00000000000000000000000000000000deadbeef")))
        expect(code!.value).to(beNil())
        expect(code!.tokenValue).to(equal(BigUInt("5")))
        expect(code!.gasLimit).to(equal(BigUInt("100000")))
        expect(code!.data).toNot(beNil())
        expect(code!.data).to(equal(Data(hex: "0xa9059cbb00000000000000000000000000000000000000000000000000000000deadbeef0000000000000000000000000000000000000000000000000000000000000005")))
        expect(code!.functionName).to(equal("transfer"))
        expect(code!.function).to(equal(.init(name: "transfer",
                                              inputs: [
                                                .init(name: "0", type: .address),
                                                .init(name: "1", type: .uint(bits: 256))
                                              ], outputs: [],
                                              constant: false,
                                              payable: false)))
        expect(code!.parameters).to(equal([
          .init(type: .address, value: Address(ethereumAddress: "0x00000000000000000000000000000000deadbeef") as AnyObject),
          .init(type: .uint(bits: 256), value: BigUInt("5") as AnyObject)
        ]))
      }
      it("should parse link from test vector 2 of (\(self.testVectors.count)") {
        let code = EIP67Code(self.testVectors[1])
        expect(code).toNot(beNil())
        expect(code!.targetAddress).toNot(beNil())
        expect(code!.targetAddress).to(equal(Address(ethereumAddress: "0xcccc00000000000000000000000000000000cccc")))
        expect(code!.recipientAddress).toNot(beNil())
        expect(code!.recipientAddress).to(equal(Address(ethereumAddress: "0xeeee00000000000000000000000000000000eeee")))
        expect(code!.value).to(beNil())
        expect(code!.tokenValue).to(equal(BigUInt("5")))
        expect(code!.gasLimit).to(equal(BigUInt("100000")))
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
          EIPQRCodeParameter(type: .address, value: Address(ethereumAddress: "0xeeee00000000000000000000000000000000eeee") as AnyObject),
          EIPQRCodeParameter(type: .uint(bits: 256), value: BigUInt("5") as AnyObject)
        ]))
      }
      it("should parse link from test vector 3 of (\(self.testVectors.count)") {
        let code = EIP67Code(self.testVectors[2])
        expect(code).toNot(beNil())
        expect(code!.targetAddress).toNot(beNil())
        expect(code!.targetAddress).to(equal(Address(ethereumAddress: "0xeeee00000000000000000000000000000000eeee")))
        expect(code!.recipientAddress).to(beNil())
        expect(code!.value).to(beNil())
        expect(code!.tokenValue).to(beNil())
        expect(code!.gasLimit).to(beNil())
        expect(code!.data).to(beNil())
        expect(code!.functionName).to(beNil())
        expect(code!.function).to(beNil())
        expect(code!.parameters).to(beEmpty())
      }
      it("should parse link from test vector 4 of (\(self.testVectors.count)") {
        let code = EIP67Code(self.testVectors[3])
        expect(code).toNot(beNil())
      }
      it("should parse link from test vector 5 of (\(self.testVectors.count)") {
        let code = EIP67Code(self.testVectors[4])
        expect(code).to(beNil())
      }
    }
  }
}
