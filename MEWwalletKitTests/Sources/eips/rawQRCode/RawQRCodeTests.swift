//
//  RawQRCodeTests.swift
//  MEWwalletKitTests
//
//  Created by Mikhail Nikanorov on 10/18/21.
//  Copyright © 2021 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import Quick
import Nimble
import BigInt
@testable import MEWwalletKit

class RawQRCodeTests: QuickSpec {
  lazy var testVectors: [String] = {
    return [
      "0xcccc00000000000000000000000000000000cccc",
      "cccc00000000000000000000000000000000cccc",
      "0xeeee00000000000000000000000000000000eee",
      "0xcccc00000000000000000000000000000000cccQ",
      "0xdeadbeef",
    ]
  }()
    
  override func spec() {
    describe("RawQRCode parsing") {
      it("should parse link from test vector 1 of (\(self.testVectors.count)") {
        let code = RawQRCode(self.testVectors[0])
        expect(code).toNot(beNil())
        expect(code!.targetAddress).toNot(beNil())
        expect(code!.targetAddress).to(equal(Address(ethereumAddress: "0xcccc00000000000000000000000000000000cccc")))
        expect(code!.recipientAddress).to(beNil())
        expect(code!.recipientAddress).to(beNil())
        expect(code!.value).to(beNil())
        expect(code!.tokenValue).to(beNil())
        expect(code!.gasLimit).to(beNil())
        expect(code!.data).to(beNil())
        expect(code!.data).to(beNil())
        expect(code!.functionName).to(beNil())
        expect(code!.function).to(beNil())
        expect(code!.parameters).to(beEmpty())
      }
      it("should parse link from test vector 2 of (\(self.testVectors.count)") {
        let code = RawQRCode(self.testVectors[1])
        expect(code).to(beNil())
      }
      it("should parse link from test vector 3 of (\(self.testVectors.count)") {
        let code = RawQRCode(self.testVectors[2])
        expect(code).to(beNil())
      }
      it("should parse link from test vector 4 of (\(self.testVectors.count)") {
        let code = RawQRCode(self.testVectors[3])
        expect(code).to(beNil())
      }
    }
  }
}
