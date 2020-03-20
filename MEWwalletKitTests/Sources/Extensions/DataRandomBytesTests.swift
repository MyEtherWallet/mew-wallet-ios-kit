//
//  DataRandomBytesTests.swift
//  MEWwalletKitTests
//
//  Created by Mikhail Nikanorov on 4/15/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MEWwalletKit

class DataRandomBytesTests: QuickSpec {
  override func spec() {
    describe("Data+RandomBytes tests") {
      it("Should generate random bytes every time") {
        var generatedData: [Data] = []
        for _ in 0 ... 1000 {
          let data = Data.randomBytes(length: 128)
          expect(data).toNot(beNil())
          
          if data != nil {
            let index = generatedData.firstIndex(of: data!)
            expect(index).to(beNil())
            generatedData.append(data!)
          } else {
            return
          }
        }
      }
    }
  }
}
