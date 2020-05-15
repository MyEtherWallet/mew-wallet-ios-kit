//
//  Transaction+RLP.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 4/25/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation

extension Transaction: RLP {
  func rlpEncode(offset: UInt8? = nil) -> Data? {
    return self.rlpData().rlpEncode()
  }
  
  internal func rlpData(chainID: BigInt<UInt8>? = nil, forSignature: Bool = false) -> [RLP] {
    var fields: [RLP] = [self._nonce, self._gasPrice, self._gasLimit]
    if let address = self.to?.address {
      fields.append(address)
    } else {
      fields.append("")
    }
    fields += [self._value, self.data]
    if let signature = self.signature, !forSignature {
      var v = BigInt<UInt8>(signature.v.reversedData.bytes)
      var r = BigInt<UInt8>(signature.r.reversedData.bytes)
      var s = BigInt<UInt8>(signature.s.reversedData.bytes)
      r.dataLength = signature.r.dataLength
      v.dataLength = signature.v.dataLength
      s.dataLength = signature.s.dataLength
      fields += [v, r, s]
    } else if let chainID = chainID ?? self.chainID {
      fields += [chainID, 0, 0]
    }
    return fields
  }
}
