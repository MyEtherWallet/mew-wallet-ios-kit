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

class Transaction: CustomDebugStringConvertible {
  internal var nonce: BigInt<UInt8>
  internal var gasPrice: BigInt<UInt8>
  internal var gasLimit: BigInt<UInt8>
  public var from: Address?
  internal var to: Address?
  internal var value: BigInt<UInt8>
  internal var data: Data
  internal var signature: TransactionSignature?
  internal var chainID: BigInt<UInt8>?
  
  init(nonce: BigInt<UInt8> = BigInt<UInt8>(0x00), gasPrice: BigInt<UInt8> = BigInt<UInt8>(0x00), gasLimit: BigInt<UInt8> = BigInt<UInt8>(0x00), to: Address?,
       value: BigInt<UInt8> = BigInt<UInt8>(0x00), data: Data = Data()) {
    self.nonce = nonce
    self.gasPrice = gasPrice
    self.gasLimit = gasLimit
    self.to = to
    self.value = value
    self.data = data
  }
  
  convenience init(nonce: Data = Data([0x00]), gasPrice: Data = Data([0x00]), gasLimit: Data = Data([0x00]), to: Address?,
                   value: Data = Data([0x00]), data: Data = Data()) {
    self.init(nonce: BigInt<UInt8>(nonce), gasPrice: BigInt<UInt8>(gasPrice), gasLimit: BigInt<UInt8>(gasLimit), to: to, value: BigInt<UInt8>(value), data: data)
  }
  
  convenience init(nonce: String = "0x00", gasPrice: String = "0x00", gasLimit: String = "0x00", to: Address?, value: String = "0x00", data: Data) throws {
    let nonce = BigInt<UInt8>(Data(hex: nonce).bytes.reversed())
    let gasPrice = BigInt<UInt8>(Data(hex: gasPrice).bytes.reversed())
    let gasLimit = BigInt<UInt8>(Data(hex: gasLimit).bytes.reversed())
    let value = BigInt<UInt8>(Data(hex: value).bytes.reversed())
    
    self.init(nonce: nonce, gasPrice: gasPrice, gasLimit: gasLimit, to: to, value: value, data: data)
  }
  
  var debugDescription: String {
    var description = "Transaction\n"
    description += "Nonce: \(self.nonce._data.toHexString())\n"
    description += "Gas Price: \(self.gasPrice._data.toHexString())\n"
    description += "Gas Limit: \(self.gasLimit._data.toHexString())\n"
    description += "From: \(String(describing: self.from)) \n"
    description += "To: \(self.to?.address ?? "")\n"
    description += "Value: \(self.value._data.toHexString())\n"
    description += "Data: \(self.data.toHexString())"
    return description
  }
  
  internal func hash(chainID: BigInt<UInt8>? = nil, forSignature: Bool = false) -> Data? {
    return self.rlpData(chainID: chainID, forSignature: forSignature).rlpEncode()?.sha3(.keccak256)
  }
}
