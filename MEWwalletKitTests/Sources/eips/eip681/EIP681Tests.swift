//
//  EIP681Tests.swift
//  MEWwalletKitTests
//
//  Created by Mikhail Nikanorov on 9/10/21.
//  Copyright © 2021 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import Quick
import Nimble
import BigInt
@testable import MEWwalletKit

class EIP681Tests: QuickSpec {
  lazy var testVectors: [String] = {
    return [
      "ethereum:pay-0xcccc00000000000000000000000000000000cccc@123/transfer?address=0xeeee00000000000000000000000000000000eeee&uint256=1.23e2&uint123=1e15",
      "ethereum:pay-0xcccc00000000000000000000000000000000cccc/transfer?address=0xeeee00000000000000000000000000000000eeee&uint256=1.23e2",
      "ethereum:pay-0xcccc00000000000000000000000000000000cccc/transfer?address=0xeeee00000000000000000000000000000000eeee",
      "ethereum:pay-0xcccc00000000000000000000000000000000cccc/transfer",
      "ethereum:pay-/transfer?address=0xeeee00000000000000000000000000000000eeee",
      "ethereum:custom-/atransfer?address=0xeeee00000000000000000000000000000000eeee",
      "ethereum:custom-0xcccc00000000000000000000000000000000cccc/atransfer?address=0xeeee00000000000000000000000000000000eeee",
      "ethereum:custom-0xcccc00000000000000000000000000000000cccc/atransfer",
      "ethereum:pay-0xcccc00000000000000000000000000000000cccc/atransfer",
      "ethereum:0xeeee00000000000000000000000000000000eeee",
      "ethereum:0xeeee00000000000000000000000000000000eeee?value=1.23e20",
      "ethereum:0xcccc00000000000000000000000000000000cccc@123/customfunction?key=value&key2=value2",
      "ethereum:@123/customfunction?key=value&key2=value2",
      "ethereum:/customfunction?key=value&key2=value2",
      "ethereum:?key=value&key2=value2"
    ]
  }()
    
  override func spec() {
    describe("EIP-681 parsing") {
      it("should parse link from test vector 1 of (\(self.testVectors.count)") {
        let code = EIP681Code(self.testVectors[0])
        expect(code).toNot(beNil())
        expect(code!.type).to(equal(.pay))
        expect(code!.targetAddress).toNot(beNil())
        expect(code!.targetAddress).to(equal(Address(ethereumAddress: "0xcccc00000000000000000000000000000000cccc")))
        expect(code!.chainID).to(equal(BigInt(123)))
        expect(code!.receipientAddress).to(equal(Address(ethereumAddress: "0xeeee00000000000000000000000000000000eeee")))
        expect(code!.value).to(beNil())
        expect(code!.gasLimit).to(beNil())
        expect(code!.functionName).to(beNil())
        expect(code!.function).to(beNil())
        expect(code!.parameters).to(equal([
          EIP681Code.Parameter(type: .address, value: Address(ethereumAddress: "0xeeee00000000000000000000000000000000eeee") as AnyObject),
          EIP681Code.Parameter(type: .uint(bits: 256), value: BigUInt("123") as AnyObject),
          EIP681Code.Parameter(type: .uint(bits: 123), value: BigUInt("1000000000000000") as AnyObject)
        ]))
      }
      it("should parse link from test vector 2 of (\(self.testVectors.count)") {
        let code = EIP681Code(self.testVectors[1])
        expect(code).toNot(beNil())
        expect(code!.type).to(equal(.pay))
        expect(code!.targetAddress).toNot(beNil())
        expect(code!.targetAddress).to(equal(Address(ethereumAddress: "0xcccc00000000000000000000000000000000cccc")))
        expect(code!.chainID).to(beNil())
        expect(code!.receipientAddress).to(equal(Address(ethereumAddress: "0xeeee00000000000000000000000000000000eeee")))
        expect(code!.value).to(beNil())
        expect(code!.gasLimit).to(beNil())
        expect(code!.functionName).to(beNil())
        expect(code!.function).to(beNil())
        expect(code!.parameters).to(equal([
          EIP681Code.Parameter(type: .address, value: Address(ethereumAddress: "0xeeee00000000000000000000000000000000eeee") as AnyObject),
          EIP681Code.Parameter(type: .uint(bits: 256), value: BigUInt("123") as AnyObject)
        ]))
      }
      it("should parse link from test vector 3 of (\(self.testVectors.count)") {
        let code = EIP681Code(self.testVectors[2])
        expect(code).toNot(beNil())
        expect(code!.type).to(equal(.pay))
        expect(code!.targetAddress).toNot(beNil())
        expect(code!.targetAddress).to(equal(Address(ethereumAddress: "0xcccc00000000000000000000000000000000cccc")))
        expect(code!.chainID).to(beNil())
        expect(code!.receipientAddress).to(equal(Address(ethereumAddress: "0xeeee00000000000000000000000000000000eeee")))
        expect(code!.value).to(beNil())
        expect(code!.gasLimit).to(beNil())
        expect(code!.functionName).to(beNil())
        expect(code!.function).to(beNil())
        expect(code!.parameters).to(equal([
          EIP681Code.Parameter(type: .address, value: Address(ethereumAddress: "0xeeee00000000000000000000000000000000eeee") as AnyObject)
        ]))
      }
      it("should parse link from test vector 4 of (\(self.testVectors.count)") {
        let code = EIP681Code(self.testVectors[3])
        expect(code).toNot(beNil())
        expect(code!.type).to(equal(.pay))
        expect(code!.targetAddress).toNot(beNil())
        expect(code!.targetAddress).to(equal(Address(ethereumAddress: "0xcccc00000000000000000000000000000000cccc")))
        expect(code!.chainID).to(beNil())
        expect(code!.receipientAddress).to(beNil())
        expect(code!.value).to(beNil())
        expect(code!.gasLimit).to(beNil())
        expect(code!.functionName).to(beNil())
        expect(code!.function).to(beNil())
        expect(code!.parameters).to(beEmpty())
      }
      it("should parse link from test vector 5 of (\(self.testVectors.count)") {
        let code = EIP681Code(self.testVectors[4])
        expect(code).to(beNil())
      }
      it("should parse link from test vector 6 of (\(self.testVectors.count)") {
        let code = EIP681Code(self.testVectors[5])
        expect(code).to(beNil())
      }
      it("should parse link from test vector 7 of (\(self.testVectors.count)") {
        let code = EIP681Code(self.testVectors[6])
        expect(code).to(beNil())
      }
      it("should parse link from test vector 8 of (\(self.testVectors.count)") {
        let code = EIP681Code(self.testVectors[7])
        expect(code).to(beNil())
      }
      it("should parse link from test vector 9 of (\(self.testVectors.count)") {
        let code = EIP681Code(self.testVectors[8])
        expect(code).toNot(beNil())
        expect(code!.type).to(equal(.pay))
        expect(code!.targetAddress).toNot(beNil())
        expect(code!.targetAddress).to(equal(Address(ethereumAddress: "0xcccc00000000000000000000000000000000cccc")))
        expect(code!.chainID).to(beNil())
        expect(code!.receipientAddress).to(beNil())
        expect(code!.value).to(beNil())
        expect(code!.gasLimit).to(beNil())
        expect(code!.functionName).to(equal("atransfer"))
        expect(code!.function).toNot(beNil())
        expect(code!.parameters).to(beEmpty())
      }
      it("should parse link from test vector 10 of (\(self.testVectors.count)") {
        let code = EIP681Code(self.testVectors[9])
        expect(code).toNot(beNil())
        expect(code!.type).to(equal(.pay))
        expect(code!.targetAddress).toNot(beNil())
        expect(code!.targetAddress).to(equal(Address(ethereumAddress: "0xeeee00000000000000000000000000000000eeee")))
        expect(code!.chainID).to(beNil())
        expect(code!.receipientAddress).to(beNil())
        expect(code!.value).to(beNil())
        expect(code!.gasLimit).to(beNil())
        expect(code!.functionName).to(beNil())
        expect(code!.function).to(beNil())
        expect(code!.parameters).to(beEmpty())
      }
      it("should parse link from test vector 11 of (\(self.testVectors.count)") {
        let code = EIP681Code(self.testVectors[10])
        expect(code).toNot(beNil())
        expect(code!.type).to(equal(.pay))
        expect(code!.targetAddress).toNot(beNil())
        expect(code!.targetAddress).to(equal(Address(ethereumAddress: "0xeeee00000000000000000000000000000000eeee")))
        expect(code!.chainID).to(beNil())
        expect(code!.receipientAddress).to(beNil())
        expect(code!.value).to(equal(BigInt("123000000000000000000")))
        expect(code!.gasLimit).to(beNil())
        expect(code!.functionName).to(beNil())
        expect(code!.function).to(beNil())
        expect(code!.parameters).to(beEmpty())
      }
      it("should parse link from test vector 12 of (\(self.testVectors.count)") {
        let code = EIP681Code(self.testVectors[11])
        expect(code).toNot(beNil())
        expect(code!.type).to(equal(.pay))
        expect(code!.targetAddress).toNot(beNil())
        expect(code!.targetAddress).to(equal(Address(ethereumAddress: "0xcccc00000000000000000000000000000000cccc")))
        expect(code!.chainID).to(equal(BigInt(123)))
        expect(code!.receipientAddress).to(beNil())
        expect(code!.value).to(beNil())
        expect(code!.gasLimit).to(beNil())
        expect(code!.functionName).to(equal("customfunction"))
        expect(code!.function).to(equal(.init(name: "customfunction",
                                              inputs: [],
                                              outputs: [],
                                              constant: false,
                                              payable: false)))
        expect(code!.parameters).to(beEmpty())
      }
      it("should parse link from test vector 13 of (\(self.testVectors.count)") {
        let code = EIP681Code(self.testVectors[12])
        expect(code).to(beNil())
      }
      it("should parse link from test vector 14 of (\(self.testVectors.count)") {
        let code = EIP681Code(self.testVectors[13])
        expect(code).to(beNil())
      }
      it("should parse link from test vector 15 of (\(self.testVectors.count)") {
        let code = EIP681Code(self.testVectors[14])
        expect(code).to(beNil())
      }
    }
  }
}
