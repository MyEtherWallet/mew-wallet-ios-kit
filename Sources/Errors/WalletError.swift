//
//  WalletError.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 12/04/20.
//  Copyright © 2020 MyEtherWallet Inc. All rights reserved.
//

import Foundation

public enum WalletError: LocalizedError {
  case emptySeed
  case emptyPrivateKey
}
