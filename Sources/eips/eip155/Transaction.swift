//
//  Transaction.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 4/25/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import BigInt

enum TransactionError: Error {
  case invalidData
}

public enum EIPTransactionType: String {
  case eip2930 = "0x01"
  case eip1559 = "0x02"
  case legacy = "0x"

  var data: Data { Data(hex: rawValue) }
}

public class Transaction: CustomDebugStringConvertible {
  internal var _nonce: BigInt
  public var nonce: Data {
    return self._nonce.data
  }

  internal var _gasLimit: BigInt
  public var gasLimit: Data {
    return self._gasLimit.data
  }
  public var from: Address?
  public var to: Address?
  internal var _value: BigInt
  public var value: Data {
    return self._value.data
  }
  internal(set) public var data: Data
  internal var signature: TransactionSignature?
  internal var chainID: BigInt?

  internal(set) public var eipType: EIPTransactionType

  //swiftlint:enable identifier_name

  init(
    nonce: BigInt = BigInt(0x00),
    gasLimit: BigInt = BigInt(0x00),
    from: Address? = nil,
    to: Address?,
    value: BigInt = BigInt(0x00),
    data: Data = Data(),
    chainID: BigInt? = nil,
    eipType: EIPTransactionType = .legacy
  ) {
    self._nonce = nonce
    self._gasLimit = gasLimit
    self.from = from
    self.to = to
    self._value = value
    self.data = data
    self.chainID = chainID
    self.eipType = eipType
  }

  public var debugDescription: String {
    var description = "Transaction\n"
    description += "Nonce: \(self._nonce.data.toHexString())\n"
    description += "Gas Limit: \(self._gasLimit.data.toHexString())\n"
    description += "From: \(String(describing: self.from)) \n"
    description += "To: \(self.to?.address ?? "")\n"
    description += "Value: \(self._value.data.toHexString())\n"
    description += "Data: \(self.data.toHexString())\n"
    description += "ChainID: \(self.chainID?.data.toHexString() ?? "none")\n"
    description += "\(self.signature?.debugDescription ?? "Signature: none")\n"
    description += "Hash: \(self.hash()?.toHexString() ?? "none")"
    return description
  }

  public func serialize() -> Data? {
    let typeData = eipType.data
    let rlpData = self.rlpData(chainID: self.chainID, forSignature: false).rlpEncode()
    return rlpData.map {
      typeData + $0
    }
  }

  internal func hash(chainID: BigInt? = nil, forSignature: Bool = false) -> Data? {
    let typeData = eipType.data
    let rlpData = self.rlpData(chainID: chainID, forSignature: forSignature).rlpEncode()

    return rlpData
      .map { typeData + $0 }?
      .sha3(.keccak256)
  }

  internal func rlpData(chainID: BigInt? = nil, forSignature: Bool = false) -> [RLP] {
    assertionFailure("Please override it in the subclass if you want to have rlp encoded values")
    return []
  }
}
