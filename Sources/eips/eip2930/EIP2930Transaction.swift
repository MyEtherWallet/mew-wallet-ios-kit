//
//  File.swift
//  
//
//  Created by Nail Galiaskarov on 6/4/21.
//

import Foundation
import BigInt

public final class EIP2930Transaction: LegacyTransaction {
  private(set) public var accessList: [AccessList]
  
  init(
    nonce: BigInt = BigInt(0x00),
    gasPrice: BigInt = BigInt(0x00),
    gasLimit: BigInt = BigInt(0x00),
    from: Address? = nil,
    to: Address?,
    value: BigInt = BigInt(0x00),
    data: Data = Data(),
    accessList: [AccessList]?,
    chainID: BigInt? = nil
  ) {
    self.accessList = accessList ?? [.empty]
    
    super.init(
      nonce: nonce,
      gasPrice: gasPrice,
      gasLimit: gasLimit,
      from: from,
      to: to,
      value: value,
      data: data,
      chainID: chainID,
      eipType: .eip2930
    )
  }

  public convenience init(
    nonce: Data = Data([0x00]),
    gasPrice: Data = Data([0x00]),
    gasLimit: Data = Data([0x00]),
    from: Address? = nil,
    to: Address?,
    value: Data = Data([0x00]),
    data: Data = Data(),
    accessList: [AccessList]?,
    chainID: Data?
  ) {
    if let chainID = chainID {
      self.init(
        nonce: BigInt(data: nonce),
        gasPrice: BigInt(data: gasPrice),
        to: to,
        value: BigInt(data: value),
        data: data,
        accessList: accessList,
        chainID: BigInt(data: chainID)
      )
    } else {
      self.init(
        nonce: BigInt(data: nonce),
        gasPrice: BigInt(data: gasPrice),
        gasLimit: BigInt(data: gasLimit),
        to: to,
        value: BigInt(data: value),
        data: data,
        accessList: accessList,
        chainID: nil
      )
    }
  }

  public convenience init(
    nonce: String = "0x00",
    gasPrice: String = "0x00",
    gasLimit: String = "0x00",
    from: Address? = nil,
    to: Address?,
    value: String = "0x00",
    data: Data,
    accessList: [AccessList]?,
    chainID: Data? = nil
  ) throws {
    let nonce = BigInt(Data(hex: nonce.stringWithAlignedHexBytes()).bytes)
    let gasPrice = BigInt(Data(hex: gasPrice.stringWithAlignedHexBytes()).bytes)
    let gasLimit = BigInt(Data(hex: gasLimit.stringWithAlignedHexBytes()).bytes)
    let value = BigInt(Data(hex: value.stringWithAlignedHexBytes()).bytes)
    if let chainID = chainID {
      self.init(
        nonce: nonce,
        gasPrice: gasPrice,
        gasLimit: gasLimit,
        from: from,
        to: to,
        value: value,
        data: data,
        accessList: accessList,
        chainID: BigInt(data: chainID)
      )
    } else {
      self.init(
        nonce: nonce,
        gasPrice: gasPrice,
        gasLimit: gasLimit,
        from: from,
        to: to,
        value: value,
        data: data,
        accessList: accessList
      )
    }
  }

  public convenience init(
    nonce: Decimal? = nil,
    gasPrice: Decimal?,
    gasLimit: Decimal?,
    from: Address? = nil,
    to: Address?,
    value: Decimal?,
    data: Data,
    accessList: [AccessList]?,
    chainID: Data? = nil
  ) throws {
    let nonceBigInt: BigInt
    let gasPriceBigInt: BigInt
    let gasLimitBigInt: BigInt
    let valueBigInt: BigInt

    if let nonceString = (nonce as NSDecimalNumber?)?.stringValue, !nonceString.isEmpty {
      nonceBigInt = BigInt(nonceString) ?? BigInt(0x00)
    } else {
      nonceBigInt = BigInt(0x00)
    }
    
    if let gasPriceString = (gasPrice as NSDecimalNumber?)?.stringValue {
      gasPriceBigInt = BigInt(gasPriceString) ?? BigInt(0x00)
    } else {
      gasPriceBigInt = BigInt(0x00)
    }

    if let gasLimitString = (gasLimit as NSDecimalNumber?)?.stringValue {
      gasLimitBigInt = BigInt(gasLimitString) ?? BigInt(0x00)
    } else {
      gasLimitBigInt = BigInt(0x00)
    }

    if let valueString = (value as NSDecimalNumber?)?.stringValue {
      valueBigInt = BigInt(valueString) ?? BigInt(0x00)
    } else {
      valueBigInt = BigInt(0x00)
    }

    if let chainID = chainID {
      self.init(
        nonce: nonceBigInt,
        gasPrice: gasPriceBigInt,
        gasLimit: gasLimitBigInt,
        from: from,
        to: to,
        value: valueBigInt,
        data: data,
        accessList: accessList,
        chainID: BigInt(data: chainID)
      )
    } else {
      self.init(
        nonce: nonceBigInt,
        gasPrice: gasPriceBigInt,
        gasLimit: gasLimitBigInt,
        from: from,
        to: to,
        value: valueBigInt,
        data: data,
        accessList: accessList
      )
    }
  }
  
  public override var debugDescription: String {
    var description = "Transaction\n"
    description += "EIPType: \(self.eipType.data.toHexString())\n"
    description += "Nonce: \(self._nonce.data.toHexString())\n"
    description += "Gas price: \(self._gasPrice.data.toHexString())\n"
    description += "Gas Limit: \(self._gasLimit.data.toHexString())\n"
    description += "From: \(String(describing: self.from)) \n"
    description += "To: \(self.to?.address ?? "")\n"
    description += "Value: \(self._value.data.toHexString())\n"
    description += "Data: \(self.data.toHexString())\n"
    description += "Access list: \n"
    accessList.forEach {
      description += "address: \($0.address?.address ?? "")\n"
      for slot in ($0.slots ?? []) {
        description += "slot: \(slot.toHexString())\n"
      }
    }

    description += "ChainID: \(self.chainID?.data.toHexString() ?? "none")\n"
    description += "\(self.signature?.debugDescription ?? "Signature: none")\n"
    description += "Hash: \(self.hash()?.toHexString() ?? "none")"
    return description
  }
  
  //
  // Creates and returns rlp array with order:
  // rlp([chainId, nonce, gasPrice, gasLimit, to, value, data, accessList, signatureYParity, signatureR, signatureS])
  //
  internal override func rlpData(chainID: BigInt? = nil, forSignature: Bool = false) -> [RLP] {
    guard let chainID = chainID else {
      return []
    }
  
    var fields: [RLP] = [chainID.toRLP(), _nonce.toRLP(), _gasPrice.toRLP(), _gasLimit.toRLP()]
    if let address = to?.address {
      fields.append(address)
    } else {
      fields.append("")
    }
    fields += [_value.toRLP(), data]
    
    let list = accessList.filter { $0.address != nil && $0.slots != nil }
    fields.append(list as [RLP])

    if let signature = signature, !forSignature {
      fields += [signature.signatureYParity, signature.r, signature.s]
    }
    return fields
  }
}
