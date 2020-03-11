//
//  RLP.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 4/25/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation

protocol RLP {
  func rlpEncode(offset: UInt8?) -> Data?
}
