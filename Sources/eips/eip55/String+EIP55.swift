//
//  String+EIP55.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 9/6/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation

extension String {
  func eip55() -> String? {
    guard self.isHex() else {
      return nil
    }
    var address = self
    let hasHexPrefix = address.hasHexPrefix()
    if hasHexPrefix {
      address.removeHexPrefix()
    }
    address = address.lowercased()
    guard let hash = address.data(using: .ascii)?.sha3(.keccak256).toHexString() else {
      return nil
    }
    
    var eip55 = zip(address, hash).map { addr, hash -> String in
      switch (addr, hash) {
      case ("0", _), ("1", _), ("2", _), ("3", _), ("4", _), ("5", _), ("6", _), ("7", _), ("8", _), ("9", _):
        return String(addr)
      case (_, "8"), (_, "9"), (_, "a"), (_, "b"), (_, "c"), (_, "d"), (_, "e"), (_, "f"):
        return String(addr).uppercased()
      default:
        return String(addr).lowercased()
      }
      }.joined()
    if hasHexPrefix {
      eip55.addHexPrefix()
    }
    return eip55
  }
}
