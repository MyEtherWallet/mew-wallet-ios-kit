//
//  Data+Hash160.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 4/22/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation

extension Data {
  func hash160() -> String? {
    return self.sha256().ripemd160().toHexString()
  }
}
