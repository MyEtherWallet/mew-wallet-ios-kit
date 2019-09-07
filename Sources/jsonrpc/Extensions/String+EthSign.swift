//
//  String+EthSign.swift
//  MEWwalletKitTests
//
//  Created by Mikhail Nikanorov on 7/24/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation

extension String {
  func hashPersonalMessage() -> Data? {
    guard let personalMessage = self.data(using: .utf8) else {
      return nil
    }
    return personalMessage.hashPersonalMessage()
  }
  
  func sign(key: Data) -> Data? {
    return self.hashPersonalMessage()?.sign(key: key)
  }
}
