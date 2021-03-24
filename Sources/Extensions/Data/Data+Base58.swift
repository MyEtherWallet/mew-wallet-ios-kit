//
//  Data+Base58.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 4/19/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation

extension Data {
  func encodeBase58(alphabet: String) -> Data? {
    let alphabetBytes = alphabet.bytes
    var value = MEWBigInt<UInt8>(self.reversed())
    let radix = MEWBigInt<UInt8>(alphabet.count)
    
    var result: [UInt8] = []
    result.reserveCapacity(bytes.count)
    
    while value > 0 {
      let (quotient, modulus) = value.quotientAndRemainder(dividingBy: radix)
      result += [alphabetBytes[Int(modulus)]]
      value = quotient
    }
    
    let prefix = Array(bytes.prefix(while: {$0 == 0}).map { _ in alphabetBytes[0] })
    result.append(contentsOf: prefix)
    result.reverse()
    
    return Data(result)
  }
  
  func encodeBase58(alphabet: String) -> String? {
    guard let data: Data = self.encodeBase58(alphabet: alphabet) else {
      return nil
    }
    return String(data: data, encoding: .utf8)
  }
}
