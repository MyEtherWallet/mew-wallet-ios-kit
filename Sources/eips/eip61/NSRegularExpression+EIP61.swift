//
//  NSRegularExpression+EIP61.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 9/11/21.
//  Copyright © 2021 MyEtherWallet Inc. All rights reserved.
//

import Foundation

private enum Static {
  static let eip61 = #"^ethereum:(?<\#(EIP61Groups.target)>[0-9a-zA-Z.]+)?[?]?(?<\#(EIP61Groups.parameters)>.+)?$"#
}

internal extension NSRegularExpression {
  static var eip61: NSRegularExpression? { return try? NSRegularExpression(pattern: Static.eip61, options: .dotMatchesLineSeparators) }
}
