//
//  EIPQRCodeParameter.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 9/13/21.
//  Copyright © 2021 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import BigInt

public struct EIPQRCodeParameter: Equatable {
  public var type: ABI.Element.ParameterType
  public var value: AnyObject
  
  public static func == (lhs: EIPQRCodeParameter, rhs: EIPQRCodeParameter) -> Bool {
    switch (lhs.value, rhs.value) {
    case let (lhsValue as Address, rhsValue as Address): return lhsValue == rhsValue && lhs.type == rhs.type
    case let (lhsValue as BigInt, rhsValue as BigInt): return lhsValue == rhsValue && lhs.type == rhs.type
    case let (lhsValue as BigUInt, rhsValue as BigUInt): return lhsValue == rhsValue && lhs.type == rhs.type
    case let (lhsValue as String, rhsValue as String): return lhsValue == rhsValue && lhs.type == rhs.type
    case let (lhsValue as Data, rhsValue as Data): return lhsValue == rhsValue && lhs.type == rhs.type
    case let (lhsValue as Bool, rhsValue as Bool): return lhsValue == rhsValue && lhs.type == rhs.type
    default: return false
    }
  }
}
