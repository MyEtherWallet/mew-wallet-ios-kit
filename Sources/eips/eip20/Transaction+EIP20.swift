//
//  Transaction+EIP20.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 8/4/20.
//  Copyright © 2020 MyEtherWallet Inc. All rights reserved.
//

import Foundation

// TODO: re-do once abi parsing is done
private let methodLength = 8
private let addressLength = 64
private let amountLength = 64

public enum TransactionType {
  case transfer(Address, String)
  case approve(Address, String)
  case basic
  case unknown(String)
  
  public init(data: String) {
    let raw = data.stringRemoveHexPrefix()
    guard raw.count > 0 else {
      self = .basic
      return
    }
    guard raw.count == methodLength + addressLength + amountLength else {
      self = .unknown(data.stringAddHexPrefix())
      return
    }
    
    let method = raw[raw.startIndex..<raw.index(raw.startIndex, offsetBy: methodLength)]
    switch method {
    case "095ea7b3":
      let startIndex = raw.index(raw.startIndex, offsetBy: method.count + addressLength - (Address.Ethereum.length - 2))
      let endIndex = raw.index(data.startIndex, offsetBy: method.count + addressLength)
      
      let rawAddress = String(raw[startIndex..<endIndex])
      let rawAmount = String(raw[endIndex..<raw.endIndex])
      
      guard let address = Address(ethereumAddress: rawAddress) else {
        self = .unknown(data.stringAddHexPrefix())
        return
      }
      
      self = .approve(address, rawAmount)
    case "a9059cbb":
      let startIndex = raw.index(raw.startIndex, offsetBy: method.count + addressLength - (Address.Ethereum.length - 2))
      let endIndex = raw.index(data.startIndex, offsetBy: method.count + addressLength)
      
      let rawAddress = String(raw[startIndex..<endIndex])
      let rawAmount = String(raw[endIndex..<raw.endIndex])
      
      guard let address = Address(ethereumAddress: rawAddress) else {
        self = .unknown(data.stringAddHexPrefix())
        return
      }
      
      self = .transfer(address, rawAmount)
    default:
      self = .unknown(data.stringAddHexPrefix())
    }
  }
  
  public init(data: Data) {
    self.init(data: data.toHexString())
  }
  
  public var method: String {
    switch self {
    case .transfer:
      return "a9059cbb"
    case .approve:
      return "095ea7b3"
    case .basic, .unknown:
      return ""
    }
  }
  
  public var data: Data? {
    switch self {
    case let .transfer(address, amount), let .approve(address, amount):
      let method = self.method
      
      var methodData = Data(hex: method.stringWithAlignedHexBytes())
      methodData.setLength(methodLength / 2, appendFromLeft: true, negative: false)
      
      var addressData = Data(hex: address.address.stringWithAlignedHexBytes())
      addressData.setLength(addressLength / 2, appendFromLeft: true, negative: false)
      
      var amountData = Data(hex: amount.stringWithAlignedHexBytes())
      amountData.setLength(amountLength / 2, appendFromLeft: true, negative: false)
      
      return methodData + addressData + amountData
    case .basic, .unknown:
      return nil
    }
  }
}

extension TransactionType: Equatable {
  public static func == (lhs: TransactionType, rhs: TransactionType) -> Bool {
    switch (lhs, rhs) {
    case let (.transfer(lhsAddress, lhsAmount), .transfer(rhsAddress, rhsAmount)):
      var lhsData = Data(hex: lhsAmount.stringWithAlignedHexBytes())
      lhsData.setLength(amountLength / 2, appendFromLeft: true, negative: false)
      var rhsData = Data(hex: rhsAmount.stringWithAlignedHexBytes())
      rhsData.setLength(amountLength / 2, appendFromLeft: true, negative: false)
      return lhsAddress == rhsAddress && lhsData == rhsData
    case let (.approve(lhsAddress, lhsAmount), .approve(rhsAddress, rhsAmount)):
      var lhsData = Data(hex: lhsAmount.stringWithAlignedHexBytes())
      lhsData.setLength(amountLength / 2, appendFromLeft: true, negative: false)
      var rhsData = Data(hex: rhsAmount.stringWithAlignedHexBytes())
      rhsData.setLength(amountLength / 2, appendFromLeft: true, negative: false)
      return lhsAddress == rhsAddress && lhsData == rhsData
    case (.basic, .basic):
      return true
    case let (.unknown(lhsData), .unknown(rhsData)):
      return lhsData == rhsData
    default:
      return false
    }
  }
}

extension Transaction {
  public var type: TransactionType {
    return TransactionType(data: self.data)
  }
}
