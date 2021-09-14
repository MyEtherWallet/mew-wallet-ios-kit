//
//  NSRegularExpression+EIP681.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 9/10/21.
//  Copyright © 2021 MyEtherWallet Inc. All rights reserved.
//

import Foundation

private enum Static {
  static let eip681 = #"^ethereum:(?>(?<\#(EIP681Groups.type)>[^-]*)-)?(?<\#(EIP681Groups.target)>[0-9a-zA-Z.]+)?(?>@(?<\#(EIP681Groups.chainID)>[0-9]+))?\/?(?>(?<\#(EIP681Groups.functionName)>[^?\n]+))?[?]?(?<\#(EIP681Groups.parameters)>.+)?$"#
}

internal extension NSRegularExpression {
  static var eip681: NSRegularExpression? { return try? NSRegularExpression(pattern: Static.eip681, options: .dotMatchesLineSeparators) }
}
