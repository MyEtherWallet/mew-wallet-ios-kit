//
//  String+Base58.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 4/19/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import BigInt

extension String {
  func decodeBase58(alphabet: String) -> Data? {
    let alphabetBytes = alphabet.bytes
    
    var result = BigInt(0)
    
    var j = BigInt(1)
    let radix = BigInt(alphabetBytes.count)
    
    let byteString = self.bytes
    let byteStringReversed = byteString.reversed()
    
    for char in byteStringReversed {
      guard let index = alphabetBytes.firstIndex(of: char) else {
        return nil
      }
      result += j * BigInt(index)
      j *= radix
    }
    
    let bytes = result.data.bytes
    var prefixData = Data()
    
    for _ in 0 ..< byteString.prefix(while: { i in i == alphabetBytes[0] }).count {
      prefixData += [0x00]
    }
    return prefixData + Data(bytes)
  }
}
