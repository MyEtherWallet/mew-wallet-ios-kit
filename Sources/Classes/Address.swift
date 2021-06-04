//
//  Address.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 4/25/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import CryptoSwift

public struct Address: CustomDebugStringConvertible {
  public struct Ethereum {
    static let length = 42
  }
  
  private var _address: String
  public var address: String {
    return self._address
  }
    
    public var data: Data {
        return Data(hex: address)
    }
  
  public init?(data: Data, prefix: String? = nil) {
    self.init(address: data.toHexString(), prefix: prefix)
  }
  
  public init(raw: String) {
    self._address = raw
  }
  
  public init?(address: String, prefix: String? = nil) {
    var address = address
    if let prefix = prefix, !address.hasPrefix(prefix) {
      address.insert(contentsOf: prefix, at: address.startIndex)
    }
    self._address = address
  }
  
  public init?(ethereumAddress: String) {
    let value = ethereumAddress.stringAddHexPrefix()
    guard value.count == Address.Ethereum.length, value.isHex(), let address = value.eip55() else { return nil } // 42 = 0x + 20bytes
    self._address = address
  }
  
  public var debugDescription: String {
    return self._address
  }
}

extension Address: Equatable {
  public static func == (lhs: Address, rhs: Address) -> Bool {
    return lhs._address.lowercased() == rhs._address.lowercased()
  }
}
