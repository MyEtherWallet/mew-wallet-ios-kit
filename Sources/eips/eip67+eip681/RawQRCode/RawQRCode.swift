//
//  RawQRCode.swift
//  MEWwalletKitTests
//
//  Created by Mikhail Nikanorov on 10/18/21.
//  Copyright © 2021 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import BigInt

public struct RawQRCode: EIPQRCode {
  
  // MARK: - Properties
  
  public var targetAddress: Address
  public var recipientAddress: Address?
  public var chainID: BigInt? { return nil }
  public var type: EIPQRCodeType { return .pay }
  public var functionName: String? { return nil }
  public var gasLimit: BigUInt? { return nil }
  public var value: BigUInt? { return nil }
  public var tokenValue: BigUInt? { return nil }
  public var function: ABI.Element.Function? { return nil }
  public var parameters: [EIPQRCodeParameter] = []
  public var data: Data? { return nil }
  
  public init(_ targetAddress: Address) {
    self.targetAddress = targetAddress
  }
  
  public init?(_ data: Data) {
    guard let val = RawQRCodeParser.parse(data) else { return nil }
    self = val
  }
  
  public init?(_ string: String) {
    guard let val = RawQRCodeParser.parse(string) else { return nil }
    self = val
  }
}

// MARK: - Parser

private struct RawQRCodeParser {
  static func parse(_ data: Data) -> RawQRCode? {
    guard let string = String(data: data, encoding: .utf8) else { return nil }
    return parse(string)
  }

  static func parse(_ string: String) -> RawQRCode? {
    guard let encoding = string.removingPercentEncoding,
          let matcher: NSRegularExpression = .rawQRCode else { return nil }
    
    let matches = matcher.matches(in: encoding, options: .anchored, range: encoding.fullNSRange)
    
    guard matches.count == 1,
          let match = matches.first else { return nil }
    
    guard let target = match.rawQRCodeTarget(in: encoding),
          let targetAddress = Address(ethereumAddress: target) else { return nil }
    
    return RawQRCode(targetAddress)
  }
}
