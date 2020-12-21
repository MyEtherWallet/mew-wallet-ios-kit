//
//  EIP2333Error.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 12/7/20.
//  Copyright © 2020 MyEtherWallet Inc. All rights reserved.
//

import Foundation

public enum EIP2333Error: Error {
  case wrongSize
  case invalidOKM
  case `internal`
}
