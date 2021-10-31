//
//  BIP39.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 4/12/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import CryptoSwift

public enum BIP39Error: Error {
  case invalidBitsOfEntropy
  case invalidEntropy
  case invalidMnemonic
  case invalidChecksum
  case invalidSalt
  case noEntropy
}

private let BIP39Salt = "mnemonic"

public final class BIP39 {
  private var _entropy: Data?
  lazy public private(set) var entropy: Data? = {
    if self._entropy != nil {
      return self._entropy
    }
    guard let mnemonic = self._mnemonic else {
      return nil
    }
    do {
      return try self.entropy(from: mnemonic)
    } catch {
      return nil
    }
  }()
  
  private var _mnemonic: [String]?
  lazy public private(set) var mnemonic: [String]? = {
    if self._mnemonic != nil {
      return self._mnemonic
    }
    guard let entropy = self._entropy else {
      return nil
    }
    
    do {
      return try self.mnemonic(from: entropy)
    } catch {
      return nil
    }
  }()

  private let language: BIP39Wordlist
  
  public init(bitsOfEntropy: Int = 256, language: BIP39Wordlist = .english) throws {
    self.language = language
    
    let entropy = try self.generateEntropy(bitsOfEntropy: bitsOfEntropy)
    self._entropy = entropy
  }
  
  public init(mnemonic: [String], language: BIP39Wordlist = .english) {
    self.language = language
    self._mnemonic = mnemonic
  }
  
  public init(entropy: Data, language: BIP39Wordlist = .english) {
    self.language = language
    self._entropy = entropy
  }
  
  public func seed(password: String = "") throws -> Data? {
    guard let mnemonic = self.mnemonic else {
      throw BIP39Error.invalidMnemonic
    }
    return try self.seed(from: mnemonic, password: password)
  }
  
  // MARK: Private
  
  private func generateEntropy(bitsOfEntropy: Int = 256) throws -> Data {
    guard bitsOfEntropy >= 128 && bitsOfEntropy <= 256 && bitsOfEntropy % 32 == 0 else {
      throw BIP39Error.invalidBitsOfEntropy
    }
    guard let entropy = Data.randomBytes(length: bitsOfEntropy / 8) else {
      throw BIP39Error.noEntropy
    }
    return entropy
  }
  
  private func mnemonic(from entropy: Data) throws -> [String] {
    guard entropy.count >= 16, entropy.count <= 32, entropy.count % 4 == 0 else {
      throw BIP39Error.invalidEntropy
    }
    let checksum = entropy.sha256()
    let checksumBits = entropy.count * 8 / 32
    var fullEntropy = Data()
    fullEntropy.append(entropy)
    fullEntropy.append(checksum[0 ..< (checksumBits + 7 ) / 8])
    var wordList: [String] = []
    for i in 0 ..< fullEntropy.count * 8 / 11 {
      guard let bits: UInt64 = fullEntropy.bits(position: i * 11, length: 11) else {
        throw BIP39Error.invalidEntropy
      }
      let index = Int(bits)
      guard language.words.count > index else {
        throw BIP39Error.invalidEntropy
      }
      let word = self.language.words[index]
      wordList.append(word)
    }
    return wordList
  }
  
  private func entropy(from mnemonic: [String]) throws -> Data {
    guard mnemonic.count >= 12 && mnemonic.count % 3 == 0 else {
      throw BIP39Error.invalidMnemonic
    }
    var bits: [Bit] = []
    for word in mnemonic {
      guard let index = language.words.firstIndex(of: word) else {
        throw BIP39Error.invalidMnemonic
      }
      let position = UInt16(self.language.words.startIndex.distance(to: index))
      
      let positionBits: [Bit] = position.bytes.flatMap { byte in
        return byte.bits()
      }
      
      guard positionBits.count == 16 else {
        throw BIP39Error.invalidMnemonic
      }
      
      bits += positionBits[5 ... 15]
    }
    guard bits.count % 33 == 0 else {
      throw BIP39Error.invalidMnemonic
    }
    
    let entropyBits = Array(bits[0 ..< (bits.count - bits.count / 33)])
    let checksumBits = Array(bits[(bits.count - bits.count / 33) ..< bits.count])
    
    let entropy = entropyBits.data()
    guard let checksum: [Bit] = entropy.sha256().bits(position: 0, length: checksumBits.count) else {
      throw BIP39Error.invalidChecksum
    }
    
    guard checksumBits.data() == checksum.data() else {
      throw BIP39Error.invalidChecksum
    }
    
    return entropy
  }
  
  private func seed(from mnemonic: [String], password: String = "") throws -> Data? {
    guard self.entropy != nil else {
      throw BIP39Error.invalidEntropy
    }
    guard let mnemonicData = mnemonic.joined(separator: " ").decomposedStringWithCompatibilityMapping.data(using: .utf8) else {
      throw BIP39Error.invalidMnemonic
    }
    let salt = BIP39Salt + password
    guard let saltData = salt.decomposedStringWithCompatibilityMapping.data(using: .utf8) else {
      throw BIP39Error.invalidSalt
    }
    
    let seed = try PKCS5.PBKDF2(password: mnemonicData.bytes, salt: saltData.bytes, iterations: 2048, keyLength: 64, variant: .sha2(.sha512)).calculate()
    return Data(seed)
  }
}
