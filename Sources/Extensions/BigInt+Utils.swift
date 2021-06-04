//
//  BigInt+Utils.swift
//  MEWwalletKit
//
//  Created by Nail Galiaskarov on 3/25/21.
//  Copyright © 2021 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import BigInt

public extension BigInt {
    var isNegative: Bool {
        return sign == .minus
    }
    
    var decimalString: String {
      return String(self, radix: 10)
    }
}
