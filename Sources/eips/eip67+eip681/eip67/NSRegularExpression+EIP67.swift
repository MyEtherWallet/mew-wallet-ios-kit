//
//  NSRegularExpression+EIP67.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 9/11/21.
//  Copyright © 2021 MyEtherWallet Inc. All rights reserved.
//

import Foundation

private enum Static {
  static let eip67 = #"^ethereum:(?<\#(EIP67Groups.target)>[0-9a-zA-Z.]+)?[?]?(?<\#(EIP67Groups.parameters)>.+)?$"#
}

internal extension NSRegularExpression {
  static var eip67: NSRegularExpression? { return try? NSRegularExpression(pattern: Static.eip67, options: .dotMatchesLineSeparators) }
}
