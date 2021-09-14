//
//  NSTextCheckingResult+EIP67.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 9/11/21.
//  Copyright © 2021 MyEtherWallet Inc. All rights reserved.
//

import Foundation

enum EIP67Groups: String {
  case target
  case parameters
}

internal extension NSTextCheckingResult {
  private var targetRange: NSRange?       { range(named: .target) }
  private var parametersRange: NSRange?   { range(named: .parameters) }
  
  func eip67Target(in string: String) -> String?       { value(of: .target, in: string) }
  func eip67Parameters(in string: String) -> String?   { value(of: .parameters, in: string) }
  
  // MARK: - Private
  
  private func range(named: EIP67Groups) -> NSRange? {
    let range = range(withName: named.rawValue)
    guard range.location != NSNotFound, range.length > 0 else { return nil }
    return range
  }
  
  private func value(of rangeName: EIP67Groups, in string: String) -> String? {
    guard let nsrange = range(named: rangeName),
          let range = Range(nsrange, in: string) else { return nil }
    return String(string[range])
  }
}
