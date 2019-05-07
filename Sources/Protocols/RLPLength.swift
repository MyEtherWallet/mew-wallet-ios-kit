//
//  RLPLength.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 4/25/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation

internal protocol RLPLength {
  func rlpLengthEncode(offset: UInt8) -> Data?
}
