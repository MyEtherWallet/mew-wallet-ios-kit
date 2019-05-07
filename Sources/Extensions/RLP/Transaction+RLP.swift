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
    var fields: [RLP] = [self.nonce, self.gasPrice, self.gasLimit]
    if let address = self.to?.address {
      fields.append(address)
    } else {
      fields.append("")
    }
    fields += [self.value, self.data]
    if let signature = self.signature, !forSignature {
      fields += [BigInt<UInt8>(signature.v._data.reversed()), BigInt<UInt8>(signature.r._data.reversed()), BigInt<UInt8>(signature.s._data.reversed())]
    } else if let chainID = chainID ?? self.chainID {
      fields += [chainID, 0, 0]
    }
    return fields
  }
}
