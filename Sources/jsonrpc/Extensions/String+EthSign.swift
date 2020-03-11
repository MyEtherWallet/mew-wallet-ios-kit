//
//  String+EthSign.swift
//  MEWwalletKitTests
//
//  Created by Mikhail Nikanorov on 7/24/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation

public extension String {
  func hashPersonalMessage() -> Data? {
    guard let personalMessage = self.data(using: .utf8) else {
      return nil
    }
    return personalMessage.hashPersonalMessage()
  }
  
  func hashPersonalMessageAndSign(key: PrivateKey, leadingV: Bool) -> Data? {
    return self.hashPersonalMessage()?.sign(key: key.data(), leadingV: leadingV)
  }
  
  func sign(key: PrivateKey, leadingV: Bool) -> Data? {
    guard let personalMessage = self.data(using: .utf8) else {
      return nil
    }
    return personalMessage.sign(key: key.data(), leadingV: leadingV)
  }
}

internal extension String {
  func hashPersonalMessageAndSign(key: Data, leadingV: Bool) -> Data? {
    return self.hashPersonalMessage()?.sign(key: key, leadingV: leadingV)
  }
  
  func sign(key: Data, leadingV: Bool) -> Data? {
    guard let personalMessage = self.data(using: .utf8) else {
      return nil
    }
    return personalMessage.sign(key: key, leadingV: leadingV)
  }
}
