//
//  File.swift
//  
//
//  Created by Nail Galiaskarov on 6/4/21.
//

import Foundation
import BigInt

public final class LegacyTransaction: Transaction {
  internal var _gasPrice: BigInt
  public var gasPrice: Data {
    return self._gasPrice.reversedData
  }
    
  init(
    nonce: BigInt = BigInt(0x00),
    gasPrice: BigInt = BigInt(0x00),
    gasLimit: BigInt = BigInt(0x00),
    from: Address? = nil,
    to: Address?,
    value: BigInt = BigInt(0x00),
    data: Data = Data(),
    chainID: BigInt? = nil
  ) {
    _gasPrice = gasPrice
    
    super.init(
      nonce: nonce,
      gasLimit: gasLimit,
      from: from,
      to: to,
      value: value,
      data: data,
      chainID: chainID,
      eipType: .legacy
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
    chainID: Data?
  ) {
    if let chainID = chainID {
        self.init(
            nonce: BigInt(data: nonce),
            gasPrice: BigInt(data: gasPrice),
            gasLimit: BigInt(data: gasLimit),
            to: to,
            value: BigInt(data: value),
            data: data,
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
        data: data
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
        data: data
      )
    }
  }
  
  public override var debugDescription: String {
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

  
  internal override func rlpData(chainID: BigInt?, forSignature: Bool = false) -> [RLP] {
    var fields: [RLP] = [self._nonce.toRLP(), self._gasPrice.toRLP(), self._gasLimit.toRLP()]
    if let address = self.to?.address {
      fields.append(address)
    } else {
      fields.append("")
    }
    fields += [self._value.toRLP(), self.data]
    if let signature = self.signature, !forSignature {
        var v = RLPBigInt(value: BigInt(signature.v.data.bytes))
        var r = RLPBigInt(value: BigInt(signature.r.data.bytes))
        var s = RLPBigInt(value: BigInt(signature.s.data.bytes))
        
        r.dataLength = signature.r.dataLength
        v.dataLength = signature.v.dataLength
        s.dataLength = signature.s.dataLength
        fields += [v, r, s]
    } else if let chainID = chainID ?? self.chainID {
        fields += [chainID.toRLP(), 0, 0]
    }
    return fields
  }
}
