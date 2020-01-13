//
//  Transaction+TokenTransfer.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 1/9/20.
//  Copyright © 2020 MyEtherWallet Inc. All rights reserved.
//

import Foundation

// TODO: unit test

public extension Transaction {
  struct TokenTransfer {
    private static let addressLength = 64
    private static let amountLength = 64
    
    public static let method = "a9059cbb"
    
    public static func address(data: String) -> Address? {
      guard data.hasPrefix(Transaction.TokenTransfer.method) else {
        return nil
      }
      // Address length without prefix
      let startIndex = data.index(data.startIndex, offsetBy: Transaction.TokenTransfer.method.count + Transaction.TokenTransfer.addressLength - (Address.Ethereum.length - 2))
      let endIndex = data.index(data.startIndex, offsetBy: Transaction.TokenTransfer.method.count + Transaction.TokenTransfer.addressLength)
      
      let address = String(data[startIndex..<endIndex])
      
      return Address(ethereumAddress: address)
    }
    
    public static func amount(data: String) -> String? {
      guard data.hasPrefix(Transaction.TokenTransfer.method) else {
        return nil
      }
      let startIndex = data.index(data.startIndex, offsetBy: Transaction.TokenTransfer.method.count + Transaction.TokenTransfer.addressLength)
      let endIndex = data.endIndex
      
      let amount = String(data[startIndex..<endIndex])
      return amount
    }
  }
}
