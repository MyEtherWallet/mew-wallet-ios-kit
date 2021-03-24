//
//  Transaction.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 4/25/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation

enum TransactionError: Error {
  case invalidData
}

public class Transaction: CustomDebugStringConvertible {
  //swiftlint:disable identifier_name
  internal var _nonce: MEWBigInt<UInt8>
  public var nonce: Data {
    return self._nonce.reversedData
  }
  
  internal var _gasPrice: MEWBigInt<UInt8>
  public var gasPrice: Data {
    return self._gasPrice.reversedData
  }
  internal var _gasLimit: MEWBigInt<UInt8>
  public var gasLimit: Data {
    return self._gasLimit.reversedData
  }
  public var from: Address?
  public var to: Address?
  internal var _value: MEWBigInt<UInt8>
  public var value: Data {
    return self._value.reversedData
  }
  internal(set) public var data: Data
  internal var signature: TransactionSignature?
  internal var chainID: MEWBigInt<UInt8>?
  //swiftlint:enable identifier_name
  
  init(nonce: MEWBigInt<UInt8> = MEWBigInt<UInt8>(0x00), gasPrice: MEWBigInt<UInt8> = MEWBigInt<UInt8>(0x00), gasLimit: MEWBigInt<UInt8> = MEWBigInt<UInt8>(0x00),
       from: Address? = nil, to: Address?, value: MEWBigInt<UInt8> = MEWBigInt<UInt8>(0x00), data: Data = Data(), chainID: MEWBigInt<UInt8>? = nil) {
    self._nonce = nonce
    self._gasPrice = gasPrice
    self._gasLimit = gasLimit
    self.from = from
    self.to = to
    self._value = value
    self.data = data
    self.chainID = chainID
  }
  
  public convenience init(nonce: Data = Data([0x00]), gasPrice: Data = Data([0x00]), gasLimit: Data = Data([0x00]), from: Address? = nil, to: Address?,
                          value: Data = Data([0x00]), data: Data = Data(), chainID: Data?) {
    if let chainID = chainID {
      self.init(nonce: MEWBigInt<UInt8>(nonce), gasPrice: MEWBigInt<UInt8>(gasPrice), gasLimit: MEWBigInt<UInt8>(gasLimit), to: to,
      value: MEWBigInt<UInt8>(value), data: data, chainID: MEWBigInt<UInt8>(chainID))
    } else {
      self.init(nonce: MEWBigInt<UInt8>(nonce), gasPrice: MEWBigInt<UInt8>(gasPrice), gasLimit: MEWBigInt<UInt8>(gasLimit), to: to,
      value: MEWBigInt<UInt8>(value), data: data, chainID: nil)
    }
  }
  
  public convenience init(nonce: String = "0x00", gasPrice: String = "0x00", gasLimit: String = "0x00", from: Address? = nil, to: Address?,
                          value: String = "0x00", data: Data, chainID: Data? = nil) throws {
    let nonce = MEWBigInt<UInt8>(Data(hex: nonce.stringWithAlignedHexBytes()).bytes.reversed())
    let gasPrice = MEWBigInt<UInt8>(Data(hex: gasPrice.stringWithAlignedHexBytes()).bytes.reversed())
    let gasLimit = MEWBigInt<UInt8>(Data(hex: gasLimit.stringWithAlignedHexBytes()).bytes.reversed())
    let value = MEWBigInt<UInt8>(Data(hex: value.stringWithAlignedHexBytes()).bytes.reversed())
    if let chainID = chainID {
      self.init(nonce: nonce, gasPrice: gasPrice, gasLimit: gasLimit, from: from, to: to, value: value, data: data, chainID: MEWBigInt<UInt8>(chainID))
    } else {
      self.init(nonce: nonce, gasPrice: gasPrice, gasLimit: gasLimit, from: from, to: to, value: value, data: data)
    }
  }
  
  public convenience init(nonce: Decimal? = nil, gasPrice: Decimal?, gasLimit: Decimal?, from: Address? = nil, to: Address?,
                          value: Decimal?, data: Data, chainID: Data? = nil) throws {
    let nonceBigInt: MEWBigInt<UInt8>
    let gasPriceBigInt: MEWBigInt<UInt8>
    let gasLimitBigInt: MEWBigInt<UInt8>
    let valueBigInt: MEWBigInt<UInt8>
    
    if let nonceString = (nonce as NSDecimalNumber?)?.stringValue, !nonceString.isEmpty {
      nonceBigInt = MEWBigInt<UInt8>(nonceString) ?? MEWBigInt<UInt8>(0x00)
    } else {
      nonceBigInt = MEWBigInt<UInt8>(0x00)
    }
    
    if let gasPriceString = (gasPrice as NSDecimalNumber?)?.stringValue {
      gasPriceBigInt = MEWBigInt<UInt8>(gasPriceString) ?? MEWBigInt<UInt8>(0x00)
    } else {
      gasPriceBigInt = MEWBigInt<UInt8>(0x00)
    }
    
    if let gasLimitString = (gasLimit as NSDecimalNumber?)?.stringValue {
      gasLimitBigInt = MEWBigInt<UInt8>(gasLimitString) ?? MEWBigInt<UInt8>(0x00)
    } else {
      gasLimitBigInt = MEWBigInt<UInt8>(0x00)
    }
    
    if let valueString = (value as NSDecimalNumber?)?.stringValue {
      valueBigInt = MEWBigInt<UInt8>(valueString) ?? MEWBigInt<UInt8>(0x00)
    } else {
      valueBigInt = MEWBigInt<UInt8>(0x00)
    }
    
    if let chainID = chainID {
      self.init(nonce: nonceBigInt, gasPrice: gasPriceBigInt, gasLimit: gasLimitBigInt, from: from, to: to, value: valueBigInt, data: data, chainID: MEWBigInt<UInt8>(chainID))
    } else {
      self.init(nonce: nonceBigInt, gasPrice: gasPriceBigInt, gasLimit: gasLimitBigInt, from: from, to: to, value: valueBigInt, data: data)
    }
  }
  
  public var debugDescription: String {
    var description = "Transaction\n"
    description += "Nonce: \(self._nonce.reversedData.toHexString())\n"
    description += "Gas Price: \(self._gasPrice.reversedData.toHexString())\n"
    description += "Gas Limit: \(self._gasLimit.reversedData.toHexString())\n"
    description += "From: \(String(describing: self.from)) \n"
    description += "To: \(self.to?.address ?? "")\n"
    description += "Value: \(self._value.reversedData.toHexString())\n"
    description += "Data: \(self.data.toHexString())\n"
    description += "ChainID: \(self.chainID?.reversedData.toHexString() ?? "none")\n"
    description += "\(self.signature?.debugDescription ?? "Signature: none")\n"
    description += "Hash: \(self.hash()?.toHexString() ?? "none")"
    return description
  }
  
  public func serialize() -> Data? {
    return self.rlpData(chainID: self.chainID, forSignature: false).rlpEncode()
  }
  
  internal func hash(chainID: MEWBigInt<UInt8>? = nil, forSignature: Bool = false) -> Data? {
    return self.rlpData(chainID: chainID, forSignature: forSignature).rlpEncode()?.sha3(.keccak256)
  }
}
