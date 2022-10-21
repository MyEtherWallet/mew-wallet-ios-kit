//
//  blsSecretKey+PublicKey.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 12/7/20.
//  Copyright © 2020 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import bls_framework

extension blsSecretKey {
  mutating func blsPublicKey() throws -> blsPublicKey {
    try BLSInterface.blsInit()
    
    var publicKey = bls_framework.blsPublicKey.init()
    blsGetPublicKey(&publicKey, &self)
    return publicKey
  }
}
