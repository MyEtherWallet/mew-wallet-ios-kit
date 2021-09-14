//
//  BigUInt+ScientificNotation.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 9/10/21.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import BigInt

extension BigUInt {
  init?(scienceNotation value: String) {
    let splittedValue = value.lowercased().split(separator: "e")
    
    switch splittedValue.count {
    case ...1:
      guard let val = BigUInt(value, radix: 10) else { return nil }
      self = val
    case 2:
      guard let power = Double(splittedValue[1]) else { return nil }
      let splittedNumber = String(splittedValue[0]).replacingOccurrences(of: ",", with: ".").split(separator: ".")
      var a = BigUInt(pow(10, power))
      switch splittedNumber.count {
      case 1:
        guard let number = BigUInt(splittedNumber[0], radix: 10) else { return nil }
        self = number * a
      case 2:
        let stringNumber = String(splittedNumber[0]) + String(splittedNumber[1])
        let am = BigUInt(pow(10, Double(splittedNumber[1].count)))
        a = a / am
        guard let number = BigUInt(stringNumber, radix: 10) else { return nil }
        self = number * a
      default:
        return nil
      }
    default:
      return nil
    }
  }
}
