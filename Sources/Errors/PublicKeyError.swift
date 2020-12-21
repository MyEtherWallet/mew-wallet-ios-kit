//
//  PublicKeyError.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 12/4/20.
//  Copyright © 2020 MyEtherWallet Inc. All rights reserved.
//

import Foundation

public enum PublicKeyError: Error {
  case invalidPrivateKey
  case internalError
  case invalidConfiguration
}
