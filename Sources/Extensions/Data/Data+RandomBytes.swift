//
//  Data+RandomBytes.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 4/12/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation

extension Data {
  
  public static func randomBytes(length: Int) -> Data? {
    for _ in 0...1024 {
      var data = Data(repeating: 0, count: length)
      let result = data.withUnsafeMutableBytes { mutableBytes -> Int32 in
        guard let baseAddress = mutableBytes.baseAddress else {
          return 0
        }
        return SecRandomCopyBytes(kSecRandomDefault, 32, baseAddress)
      }
      if result == errSecSuccess {
        return data
      }
    }
    return nil
  }
  
}
