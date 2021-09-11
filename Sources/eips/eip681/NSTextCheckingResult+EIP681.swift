//
//  NSTextCheckingResult+EIP681.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 9/10/21.
//  Copyright © 2021 MyEtherWallet Inc. All rights reserved.
//

import Foundation

enum EIP681Groups: String {
  case type
  case target
  case chainID
  case functionName
  case parameters
}

internal extension NSTextCheckingResult {
  private var typeRange: NSRange?         { range(named: .type) }
  private var targetRange: NSRange?       { range(named: .target) }
  private var chainIDRange: NSRange?      { range(named: .chainID) }
  private var functionNameRange: NSRange? { range(named: .functionName) }
  private var parametersRange: NSRange?   { range(named: .parameters) }
  
  func eip681Type(in string: String) -> String?         { value(of: .type, in: string) }
  func eip681Target(in string: String) -> String?       { value(of: .target, in: string) }
  func eip681ChainID(in string: String) -> String?      { value(of: .chainID, in: string) }
  func eip681FunctionName(in string: String) -> String? { value(of: .functionName, in: string) }
  func eip681Parameters(in string: String) -> String?   { value(of: .parameters, in: string) }
  
  // MARK: - Private
  
  private func range(named: EIP681Groups) -> NSRange? {
    let range = range(withName: named.rawValue)
    guard range.location != NSNotFound, range.length > 0 else { return nil }
    return range
  }
  
  private func value(of rangeName: EIP681Groups, in string: String) -> String? {
    guard let nsrange = range(named: rangeName),
          let range = Range(nsrange, in: string) else { return nil }
    return String(string[range])
  }
}
