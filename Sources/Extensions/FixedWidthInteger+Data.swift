//
//  FixedWidthInteger+Data.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 4/16/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation

extension FixedWidthInteger {
  var bytes: [UInt8] {
    let data = withUnsafeBytes(of: self) { Data($0) }
    
    return data.bytes.reversed()
  }
}
