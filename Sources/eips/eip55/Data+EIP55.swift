//
//  Data+EIP55.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 4/23/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation

extension Data {
  func eip55() -> String? {
    return self.toHexString().eip55()
  }
}
