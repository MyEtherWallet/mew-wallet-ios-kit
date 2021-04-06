//
//  File.swift
//  
//
//  Created by Nail Galiaskarov on 3/25/21.
//

import Foundation
import BigInt

public struct RLPBigInt {
    public let value: BigInt
    
    public init(value: BigInt) {
        self.value = value
    }
    
    private var _dataCount: Int?
    
    var dataLength: Int {
      get {
        return self._dataCount ?? _data.count
      }
      set {
        _dataCount = newValue
      }
    }
    
    internal var data: Data {
      var data = Data(_data)
      if let count = self._dataCount {
        data.setLength(count, appendFromLeft: true)
      }
      return data
    }
    
    internal var reversedData: Data {
      var data = Data(_data.reversed())
      if let count = self._dataCount {
        data.setLength(count, appendFromLeft: false)
      }
      return data
    }

    private var _data: [UInt8] {
        return value.toTwosComplement().bytes
    }
}

extension BigInt {
    func toRLP() -> RLPBigInt {
        return RLPBigInt(value: self)
    }
}
