//
//  Data+ConstantTimeComparison.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 4/25/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation

extension Data {
  func secureCompare(_ rhs: Data) -> Bool {
    guard self.count == rhs.count else { return false }
    var difference = UInt8(0x00)
    for i in 0 ..< self.count {
      difference |= self[i] ^ rhs[i]
    }
    return difference == UInt8(0x00)
  }
}
