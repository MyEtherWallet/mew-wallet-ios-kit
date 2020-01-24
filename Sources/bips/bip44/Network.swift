//
//  Network.swift
//  MEWwalletKit
//
//  Created by Mikhail Nikanorov on 4/17/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation

public enum Network {
  case bitcoin
  case litecoin
  case singularDTV
  case ropsten
  case expanse
  case ledgerLiveEthereum
  case keepkeyEthereum
  case ledgerEthereum
  case ethereum
  case ledgerEthereumClassic
  case ledgerEthereumClassicVintage
  case ledgerLiveEthereumClassic
  case keepkeyEthereumClassic
  case ethereumClassic
  case mixBlockchain
  case ubiq
  case rskMainnet
  case ellaism
  case pirl
  case musicoin
  case callisto
  case tomoChain
  case thundercore
  case ethereumSocial
  case atheios
  case etherGem
  case eosClassic
  case goChain
  case etherSocialNetwork
  case rskTestnet
  case akroma
  case iolite
  case ether1
  case anonymizedId
  case custom(name: String, path: String, chainID: UInt32)
  
  public init(path: String) {
    switch path {
    case "m/0'/0'/0'":
      self = .singularDTV
    case "m/44'/0'/0'/0":
      self = .bitcoin
    case "m/44'/1'/0'/0":
      self = .ropsten
    case "m/44'/2'/0'/0":
      self = .litecoin
    case "m/44'/40'/0'/0":
      self = .expanse
    case "m/44'/60'":
      self = .keepkeyEthereum
    case "m/44'/60'/0":
      self = .ledgerEthereum
    case "m/44'/60'/0'/0":
      self = .ethereum
    case "m/44'/60'/160720'/0":
      self = .ledgerEthereumClassic
    case "m/44'/60'/160720'/0'":
      self = .ledgerEthereumClassicVintage
    case "m/44'/61'":
      self = .keepkeyEthereumClassic
    case "m/44'/61'/0'/0":
      self = .ethereumClassic
    case "m/44'/76'/0'/0":
      self = .mixBlockchain
    case "m/44'/108'/0'/0":
      self = .ubiq
    case "m/44'/137'/0'/0":
      self = .rskMainnet
    case "m/44'/163'/0'/0":
      self = .ellaism
    case "m/44'/164'/0'/0":
      self = .pirl
    case "m/44'/184'/0'/0":
      self = .musicoin
    case "m/44'/820'/0'/0":
      self = .callisto
    case "m/44'/889'/0'/0":
      self = .tomoChain
    case "m/44'/1001'/0'/0":
      self = .thundercore
    case "m/44'/1128'/0'/0":
      self = .ethereumSocial
    case "m/44'/1620'/0'/0":
      self = .atheios
    case "m/44'/1987'/0'/0":
      self = .etherGem
    case "m/44'/2018'/0'/0":
      self = .eosClassic
    case "m/44'/6060'/0'/0":
      self = .goChain
    case "m/44'/31102'/0'/0":
      self = .etherSocialNetwork
    case "m/44'/37310'/0'/0":
      self = .rskTestnet
    case "m/44'/200625'/0'/0":
      self = .akroma
    case "m/44'/1171337'/0'/0":
      self = .iolite
    case "m/44'/1313114'/0'/0":
      self = .ether1
    case "m/1000'/60'/0'/0":
      self = .anonymizedId
    default:
      self = .custom(name: path, path: path, chainID: 0)
    }
  }
  
  public var name: String {
    switch self {
    case .bitcoin:
      return "Bitcoin"
    case .litecoin:
      return "Litecoin"
    case .singularDTV:
      return "SingularDTV"
    case .ropsten:
      return "Ropsten"
    case .expanse:
      return "Expanse"
    case .ledgerLiveEthereum:
      return "Ethereum - Ledger Live"
    case .ethereum, .ledgerEthereum, .keepkeyEthereum:
      return "Ethereum"
    case .ledgerEthereumClassicVintage:
      return "Ethereum Classic MEW Vintage"
    case .ledgerLiveEthereumClassic:
      return "Ethereum Classic - Ledger Live"
    case .ethereumClassic, .ledgerEthereumClassic, .keepkeyEthereumClassic:
      return "Ethereum Classic"
    case .mixBlockchain:
      return "Mix Blockchain"
    case .ubiq:
      return "Ubiq"
    case .rskMainnet:
      return "RSK Mainnet"
    case .ellaism:
      return "Ellaism"
    case .pirl:
      return "PIRL"
    case .musicoin:
      return "Musicoin"
    case .callisto:
      return "Callisto"
    case .tomoChain:
      return "TomoChain"
    case .thundercore:
      return "ThunderCore"
    case .ethereumSocial:
      return "Ethereum Social"
    case .atheios:
      return "Atheios"
    case .etherGem:
      return "EtherGem"
    case .eosClassic:
      return "EOS Classic"
    case .goChain:
      return "GoChain"
    case .etherSocialNetwork:
      return "EtherSocial Network"
    case .rskTestnet:
      return "RSK Testnet"
    case .akroma:
      return "Akroma"
    case .iolite:
      return "Iolite"
    case .ether1:
      return "Ether-1"
    case .anonymizedId:
      return "AnonymizedId"
    case let .custom(name, _, _):
      return name
    }
  }
  
  public var path: String {
    switch self {
    case .singularDTV:
      return "m/0'/0'/0'"
    case .bitcoin:
      return "m/44'/0'/0'/0"
    case .ropsten:
      return "m/44'/1'/0'/0"
    case .litecoin:
      return "m/44'/2'/0'/0"
    case .expanse:
      return "m/44'/40'/0'/0"
    case .ledgerLiveEthereum, .keepkeyEthereum:
      return "m/44'/60'"
    case .ledgerEthereum:
      return "m/44'/60'/0"
    case .ethereum:
      return "m/44'/60'/0'/0"
    case .ledgerEthereumClassic:
      return "m/44'/60'/160720'/0"
    case .ledgerEthereumClassicVintage:
      return "m/44'/60'/160720'/0'"
    case .ledgerLiveEthereumClassic, .keepkeyEthereumClassic:
      return "m/44'/61'"
    case .ethereumClassic:
      return "m/44'/61'/0'/0"
    case .mixBlockchain:
      return "m/44'/76'/0'/0"
    case .ubiq:
      return "m/44'/108'/0'/0"
    case .rskMainnet:
      return "m/44'/137'/0'/0"
    case .ellaism:
      return "m/44'/163'/0'/0"
    case .pirl:
      return "m/44'/164'/0'/0"
    case .musicoin:
      return "m/44'/184'/0'/0"
    case .callisto:
      return "m/44'/820'/0'/0"
    case .tomoChain:
      return "m/44'/889'/0'/0"
    case .thundercore:
      return "m/44'/1001'/0'/0"
    case .ethereumSocial:
      return "m/44'/1128'/0'/0"
    case .atheios:
      return "m/44'/1620'/0'/0"
    case .etherGem:
      return "m/44'/1987'/0'/0"
    case .eosClassic:
      return "m/44'/2018'/0'/0"
    case .goChain:
      return "m/44'/6060'/0'/0"
    case .etherSocialNetwork:
      return "m/44'/31102'/0'/0"
    case .rskTestnet:
      return "m/44'/37310'/0'/0"
    case .akroma:
      return "m/44'/200625'/0'/0"
    case .iolite:
      return "m/44'/1171337'/0'/0"
    case .ether1:
      return "m/44'/1313114'/0'/0"
    case .anonymizedId:
      return "m/1000'/60'/0'/0"
    case let .custom(_, path, _):
      return path
    }
  }
  
  public var chainID: UInt32 {
    switch self {
    case .singularDTV:
      return 0
    case .bitcoin:
      return 0
    case .ropsten:
      return 3
    case .litecoin:
      return 2
    case .expanse:
      return 2
    case .ledgerLiveEthereum, .keepkeyEthereum:
      return 1
    case .ledgerEthereum:
      return 1
    case .ethereum:
      return 1
    case .ledgerEthereumClassic:
      return 1
    case .ledgerEthereumClassicVintage:
      return 1
    case .ledgerLiveEthereumClassic, .keepkeyEthereumClassic:
      return 44
    case .ethereumClassic:
      return 61
    case .mixBlockchain:
      return 76
    case .ubiq:
      return 8
    case .rskMainnet:
      return 30
    case .ellaism:
      return 64
    case .pirl:
      return 3125659152
    case .musicoin:
      return 7762959
    case .callisto:
      return 820
    case .tomoChain:
      return 88
    case .thundercore:
      return 108
    case .ethereumSocial:
      return 1128
    case .atheios:
      return 1620
    case .etherGem:
      return 1987
    case .eosClassic:
      return 2018
    case .goChain:
      return 60
    case .etherSocialNetwork:
      return 31102
    case .rskTestnet:
      return 31
    case .akroma:
      return 200625
    case .iolite:
      return 18289463
    case .ether1:
      return 1313114
    case .anonymizedId:
      return 1
    case let .custom(_, _, chainID):
      return chainID
    }
  }
  
  var wifPrefix: UInt8? {
    switch self {
    case .bitcoin:
      return 0x80
    case .litecoin:
      return 0xB0
    default:
      return nil
    }
  }
  
  var publicKeyHash: UInt8 {
    switch self {
    case .bitcoin:
      return 0x00
    case .litecoin:
      return 0x30
    default:
      return 0x00
    }
  }
  
  var addressPrefix: String {
    switch self {
    case .bitcoin:
      return ""
    case .ethereum, .ropsten, .anonymizedId:
      return "0x"
    default:
      return "0x"
    }
  }
  
  var alphabet: String? {
    switch self {
    case .bitcoin:
      return "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
    default:
      return nil
    }
  }
  
  var privateKeyPrefix: UInt32 {
    switch self {
    case .bitcoin:
      return 0x0488ADE4
    case .ropsten:
      return 0x04358394
    default:
      return 0
    }
  }
  
  var publicKeyPrefix: UInt32 {
    switch self {
    case .bitcoin:
      return 0x0488b21e
    case .ropsten:
      return 0x043587cf
    default:
      return 0
    }
  }
  
  var publicKeyCompressed: Bool {
    switch self {
    case .bitcoin, .litecoin:
      return true
    case .ethereum, .ropsten, .anonymizedId:
      return false
    default:
      return false
    }
  }
  
  public var symbol: String {
    switch self {
    case .bitcoin:
      return "btc"
    case .ethereum:
      return "eth"
    case .ropsten:
      return "rop"
    default:
      return ""
    }
  }
}
