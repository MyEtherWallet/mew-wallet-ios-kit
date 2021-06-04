//
//  File.swift
//
//
//  Created by Nail Galiaskarov on 6/4/21.
//

import Foundation
import BigInt

public final class EIP1559Transaction: Transaction {
  internal var _maxPriorityFeePerGas: BigInt
  public var maxPriorityFeePerGas: Data {
    return _maxPriorityFeePerGas.reversedData
  }

  internal var _maxFeePerGas: BigInt
  public var maxFeePerGas: Data {
    return _maxFeePerGas.reversedData
  }

  init(
    nonce: BigInt = BigInt(0x00),
    maxPriorityFeePerGas: BigInt = BigInt(0x00),
    maxFeePerGas: BigInt = BigInt(0x00),
    gasLimit: BigInt = BigInt(0x00),
    from: Address? = nil,
    to: Address?,
    value: BigInt = BigInt(0x00),
    data: Data = Data(),
    chainID: BigInt? = nil
  ) {
    _maxPriorityFeePerGas = maxPriorityFeePerGas
    _maxFeePerGas = maxFeePerGas
    
    super.init(
      nonce: nonce,
      gasLimit: gasLimit,
      from: from,
      to: to,
      value: value,
      data: data,
      chainID: chainID,
      eipType: .eip1559
    )
  }

  public convenience init(
    nonce: Data = Data([0x00]),
    maxPriorityFeePerGas: Data = Data([0x00]),
    maxFeePerGas: Data = Data([0x00]),
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
            maxPriorityFeePerGas: BigInt(data: maxPriorityFeePerGas),
            maxFeePerGas: BigInt(data: maxFeePerGas),
            to: to,
            value: BigInt(data: value),
            data: data,
            chainID: BigInt(data: chainID)
        )
    } else {
        self.init(
            nonce: BigInt(data: nonce),
            maxPriorityFeePerGas: BigInt(data: maxPriorityFeePerGas),
            maxFeePerGas: BigInt(data: maxFeePerGas),
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
    maxPriorityFeePerGas: String = "0x00",
    maxFeePerGas: String = "0x00",
    gasLimit: String = "0x00",
    from: Address? = nil,
    to: Address?,
    value: String = "0x00",
    data: Data,
    chainID: Data? = nil
  ) throws {
    let nonce = BigInt(Data(hex: nonce.stringWithAlignedHexBytes()).bytes)
    let maxPriorityFeePerGas = BigInt(Data(hex: maxPriorityFeePerGas.stringWithAlignedHexBytes()).bytes)
    let maxFeePerGas = BigInt(Data(hex: maxFeePerGas.stringWithAlignedHexBytes()).bytes)
    let gasLimit = BigInt(Data(hex: gasLimit.stringWithAlignedHexBytes()).bytes)
    let value = BigInt(Data(hex: value.stringWithAlignedHexBytes()).bytes)
    if let chainID = chainID {
      self.init(
        nonce: nonce,
        maxPriorityFeePerGas: maxPriorityFeePerGas,
        maxFeePerGas: maxFeePerGas,
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
        maxPriorityFeePerGas: maxPriorityFeePerGas,
        maxFeePerGas: maxFeePerGas,
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
    maxPriorityFeePerGas: Decimal?,
    maxFeePerGas: Decimal?,
    gasLimit: Decimal?,
    from: Address? = nil,
    to: Address?,
    value: Decimal?,
    data: Data,
    chainID: Data? = nil
  ) throws {
    let nonceBigInt: BigInt
    let maxPriorityFeePerGasBigInt: BigInt
    let maxFeePerGasBigInt: BigInt
    let gasLimitBigInt: BigInt
    let valueBigInt: BigInt

    if let nonceString = (nonce as NSDecimalNumber?)?.stringValue, !nonceString.isEmpty {
      nonceBigInt = BigInt(nonceString) ?? BigInt(0x00)
    } else {
      nonceBigInt = BigInt(0x00)
    }

    if let maxPriorityFeePerGasString = (maxPriorityFeePerGas as NSDecimalNumber?)?.stringValue {
      maxPriorityFeePerGasBigInt = BigInt(maxPriorityFeePerGasString) ?? BigInt(0x00)
    } else {
      maxPriorityFeePerGasBigInt = BigInt(0x00)
    }

    if let maxFeePerGasString = (maxFeePerGas as NSDecimalNumber?)?.stringValue {
      maxFeePerGasBigInt = BigInt(maxFeePerGasString) ?? BigInt(0x00)
    } else {
      maxFeePerGasBigInt = BigInt(0x00)
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
        maxPriorityFeePerGas: maxPriorityFeePerGasBigInt,
        maxFeePerGas: maxFeePerGasBigInt,
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
        maxPriorityFeePerGas: maxPriorityFeePerGasBigInt,
        maxFeePerGas: maxFeePerGasBigInt,
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
    description += "Max Priority Fee Per Gas: \(self._maxPriorityFeePerGas.reversedData.toHexString())\n"
    description += "Max Fee Per Gas: \(self._maxFeePerGas.reversedData.toHexString())\n"
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
  
  //
  // Creates and returns rlp array with order:
  // RLP([chainId, nonce, maxPriorityFeePerGas, maxFeePerGas, gasLimit, to, value, data, accessList, signatureYParity, signatureR, signatureS])
  //
  internal override func rlpData(chainID: BigInt? = nil, forSignature: Bool = false) -> [RLP] {
    guard let chainID = chainID else {
      return []
    }
  
    var fields: [RLP] = [chainID.toRLP(), _nonce.toRLP(), _maxPriorityFeePerGas.toRLP(), _maxFeePerGas.toRLP(), _gasLimit.toRLP()]
    if let address = self.to?.address {
      fields.append(address)
    } else {
      fields.append("")
    }
    fields += [self._value.toRLP(), self.data]
    
    // TODO: Add Access list
    
    if let signature = self.signature, !forSignature {
      var signatureYParity = RLPBigInt(value: BigInt(signature.signatureYParity.data.bytes))
      var r = RLPBigInt(value: BigInt(signature.r.data.bytes))
      var s = RLPBigInt(value: BigInt(signature.s.data.bytes))
      
      r.dataLength = signature.r.dataLength
      signatureYParity.dataLength = signature.signatureYParity.dataLength
      s.dataLength = signature.s.dataLength
      fields += [signatureYParity, r, s]
    }
    return fields
  }
}

