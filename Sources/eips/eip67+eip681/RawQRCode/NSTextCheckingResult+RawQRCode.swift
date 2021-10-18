//
//  NSTextCheckingResult+RawQRCode.swift
//  MEWwalletKitTests
//
//  Created by Mikhail Nikanorov on 10/18/21.
//  Copyright © 2021 MyEtherWallet Inc. All rights reserved.
//

import Foundation

enum RawQRCodeGroups: String {
  case target
}

internal extension NSTextCheckingResult {
  private var targetRange: NSRange?       { range(named: .target) }
  
  func rawQRCodeTarget(in string: String) -> String?      { value(of: .target, in: string) }
  
  // MARK: - Private
  
  private func range(named: RawQRCodeGroups) -> NSRange? {
    let range = range(withName: named.rawValue)
    guard range.location != NSNotFound, range.length > 0 else { return nil }
    return range
  }
  
  private func value(of rangeName: RawQRCodeGroups, in string: String) -> String? {
    guard let nsrange = range(named: rangeName),
          let range = Range(nsrange, in: string) else { return nil }
    return String(string[range])
  }
}
