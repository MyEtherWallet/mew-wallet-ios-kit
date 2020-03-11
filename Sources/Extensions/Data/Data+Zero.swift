//
//  Data+Zero.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 4/18/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation

extension Data {
  mutating func zero() {
    let count = self.count
    
    self.withUnsafeMutableBytes { mutableBytes -> Void in
      guard let baseAddress = mutableBytes.baseAddress else {
        return
      }
      baseAddress.initializeMemory(as: UInt8.self, repeating: 0, count: count)
    }
  }
}
