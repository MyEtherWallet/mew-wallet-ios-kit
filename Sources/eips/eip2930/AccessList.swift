//
//  File.swift
//  
//
//  Created by Nail Galiaskarov on 6/9/21.
//

import Foundation

typealias StorageSlot = Data

public struct AccessList {
  let address: Address?
  let slots: [StorageSlot]?
  
  static var empty = AccessList(address: nil, slots: nil)
}

extension AccessList: RLP {
  func rlpEncode(offset: UInt8?) -> Data? {
    guard let address = address, let slots = slots else {
      return nil
    }
    let rlp: [RLP] = [address.address, slots as [RLP]]
    return rlp.rlpEncode(offset: offset)
  }
}
