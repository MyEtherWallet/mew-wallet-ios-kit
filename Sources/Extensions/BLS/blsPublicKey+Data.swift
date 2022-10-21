//
//  blsPublicKey+Data.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 12/7/20.
//  Copyright © 2020 MyEtherWallet Inc. All rights reserved.
//


import Foundation
import bls_framework

private let PUBLIC_KEY_LENGHT = 48

extension blsPublicKey {
  mutating func serialize() -> Data {
    var bytes = Data(count: PUBLIC_KEY_LENGHT).bytes
    blsPublicKeySerialize(&bytes, PUBLIC_KEY_LENGHT, &self)
    
    return Data(bytes)
  }
}
