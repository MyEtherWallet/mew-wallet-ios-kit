//
//  Address.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 4/25/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation

struct Address: CustomDebugStringConvertible {
  private var _address: String
  var address: String {
    return self._address
  }
  
  init?(_ address: String) {
    guard address.count == 42, address.isHex() else { return nil } //42 = 0x + 20bytes
    self._address = address
  }
  
  var debugDescription: String {
    return self._address
  }
}
