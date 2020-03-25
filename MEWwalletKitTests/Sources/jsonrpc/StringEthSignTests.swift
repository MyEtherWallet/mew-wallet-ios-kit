//
//  StringEthSignTests.swift
//  MEWwalletKitTests
//
//  Created by Mikhail Nikanorov on 7/24/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MEWwalletKit
import secp256k1

class StringEthSignTests: QuickSpec {
  override func spec() {
    describe("JSON RPC tests") {
      it("Should correctly hash personal message") {
        let testMessage = "41d1c8f0d3781e50f84996fc655ee564982a88be8da4952d9eddb516db06d588"
        let testHash = Data([0xe2, 0x45, 0x10, 0x93, 0x83, 0xa4, 0x80, 0xc0, 0x86, 0x80, 0x18, 0xca, 0x92, 0x8c, 0xbe, 0xd5, 0x77, 0x21, 0x39, 0xa4, 0x31, 0x04, 0x7f, 0xef, 0xb5,
                             0xc5, 0xf0, 0x46, 0x59, 0x24, 0x65, 0x75])
        
        let hash = testMessage.hashPersonalMessage()
        expect(testHash) == hash
      }
    }
  }
}
