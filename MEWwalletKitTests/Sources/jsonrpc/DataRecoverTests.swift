//
//  DataRecoverTests.swift
//  MEWwalletKit
//
//  Created by Ronald Mannak on 3/24/22.
//

import Foundation
import Quick
import Nimble
@testable import MEWwalletKit
import MEW_wallet_iOS_secp256k1_package

class DataRecoverTests: QuickSpec {
  
  class TestVector {
    let hash: Data
    let signature: Data
    let address: Address?
    
    init(_ hash: String, _ signature: String, _ address: String) {
      self.hash = hash.hashPersonalMessage()!
      self.signature = Data(hex: signature)
      self.address = Address(ethereumAddress: address)
    }
  }
  
  lazy var testVectors: [TestVector] = {
    let vector: [TestVector] = [
      TestVector("Hello from MEW",
                 "e0d2bcd9be5cda484507ca00b2dead459f695761af466da6c807041e34256c5832addbe5932574561e0915fe99ec1b26225893d90a750d8404df681ba0183df51c",
                 "0x812CeF66396710a1e4BA08F22D0E3e6a1D790d19"),
      TestVector("Mismatch message and signature should return incorrect address",
                 "e0d2bcd9be5cda484507ca00b2dead459f695761af466da6c807041e34256c5832addbe5932574561e0915fe99ec1b26225893d90a750d8404df681ba0183df51c",
                 "0x7521e01058114D058d1F78f8eFE91B60bD9Dbf9b"),
      TestVector("Example `personal_sign` message",
                 "0x1abbaaf449dca088eecbf9a8410185868eb84d2d23e8c379ba4f31fce2660375250ca156f84e7e4f85f4e23f2a93c86a2066b371fca595a3d547ec018dbc560c1c",
                 "0x00d9592423e5933fd5c7765eca3704760133fcd4")
    ]
    return vector
  }()
  
  override func spec() {
    describe("signature verification tests") {
      it("should verify signature") {
        for vector in self.testVectors {
          let address = vector.hash.recover(with: vector.signature)
          expect(address).to(equal(vector.address))
        }
      }
    }
  }
}
