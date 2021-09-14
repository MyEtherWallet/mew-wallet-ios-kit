//
//  EIPQRCode.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 9/13/21.
//  Copyright © 2021 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import BigInt

public protocol EIPQRCode {
  var chainID: BigInt? { get }
  var targetAddress: Address { get }
  var recipientAddress: Address? { get }
  var value: BigUInt? { get }
  var tokenValue: BigUInt? { get }
  var gasLimit: BigUInt? { get }
  var data: Data? { get }
  var functionName: String? { get }
  var function: ABI.Element.Function? { get }
  var parameters: [EIPQRCodeParameter] { get }
}
