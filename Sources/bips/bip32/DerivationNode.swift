//
//  DerivationNode.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 4/17/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation

enum DerivationNodeError: Error {
  case invalidPath
  case invalidChildIndex
}

private let hardenedCharacter = "'"
private let hardenedCharacterSet = CharacterSet(charactersIn: hardenedCharacter)
private let hardenedEdge: UInt32 = 0x80000000

public enum DerivationNode {
  case hardened(UInt32)
  case nonHardened(UInt32)
  
  init?(component: String, checkHardenedEdge: Bool) throws {
    guard !component.hasPrefix("m") else {
      return nil
    }
    guard let index = UInt32(component.trimmingCharacters(in: hardenedCharacterSet)) else {
      throw DerivationNodeError.invalidPath
    }
    if checkHardenedEdge {
      guard hardenedEdge & index == 0 else {
        throw DerivationNodeError.invalidChildIndex
      }
    }
    
    if component.hasSuffix(hardenedCharacter) {
      self = .hardened(hardenedEdge | index)
    } else {
      self = .nonHardened(index)
    }
  }
  
  func index() -> UInt32 {
    switch self {
    case let .hardened(index):
      return index
    case let .nonHardened(index):
      return index
    }
  }
  
  static func nodes(path: String, checkHardenedEdge: Bool) throws -> [DerivationNode] {
    var nodes: [DerivationNode] = []
    let components = path.components(separatedBy: "/")
    
    for component in components {
      if let node = try DerivationNode(component: component, checkHardenedEdge: checkHardenedEdge) {
        nodes.append(node)
      }
    }
    
    return nodes
  }
}

extension DerivationNode: CustomDebugStringConvertible {
  public var debugDescription: String {
    switch self {
    case let .hardened(index):
      return "\(index)'"
    case let .nonHardened(index):
      return "\(index)"
    }
  }
}

public extension String {
  func derivationPath(checkHardenedEdge: Bool) throws -> [DerivationNode] {
    return try DerivationNode.nodes(path: self, checkHardenedEdge: checkHardenedEdge)
  }
}
