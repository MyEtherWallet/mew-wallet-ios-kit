//
//  Address.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 4/25/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation

public struct Address: CustomDebugStringConvertible {
  private var _address: String
  public var address: String {
    return self._address
  }
  
  public init?(_ address: String) {
    guard address.count == 42, address.isHex() else { return nil } //42 = 0x + 20bytes
    self._address = address
  }
  
  public var debugDescription: String {
    return self._address
  }
}
