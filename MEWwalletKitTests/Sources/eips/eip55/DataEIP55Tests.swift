//
//  DataEIP55Tests.swift
//  MEWwalletKitTests
//
//  Created by Mikhail Nikanorov on 4/23/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Quick
import Nimble
@testable import MEWwalletKit

class DataEIP55Tests: QuickSpec {
  let testVectors = [
  //All upper
  "52908400098527886E0F7030069857D2E4169EE7",
  "8617E340B3D01FA5F11F306F4090FD50E238070D",
  //All lower
  "de709f2102306220921060314715629080e2fb77",
  "27b1fdb04752bbc536007a920d24acb045561c26",
  //Normal
  "5aAeb6053F3E94C9b9A09f33669435E7Ef1BeAed",
  "fB6916095ca1df60bB79Ce92cE3Ea74c37c5d359",
  "dbF03B407c01E7cD3CBea99509d93f8DDDC8C6FB",
  "D1220A0cf47c7B9Be7A2E6BA89F429762e7b9aDb"
  ]
  
  override func spec() {
    describe("EIP55 Tests") {
      it("Should correctly format data") {
        for vector in self.testVectors {
          let data = Data(hex: vector.lowercased())
          
          expect(data.eip55()).to(equal(vector))
        }
      }
    }
  }
}
