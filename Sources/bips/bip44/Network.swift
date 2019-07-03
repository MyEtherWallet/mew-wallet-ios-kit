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
  case custom(name: String, path: String)
  
  var name: String {
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
    case let .custom(name, _):
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
    case let .custom(_, path):
      return path
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
    case .ethereum, .ropsten:
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
    case .ethereum, .ropsten:
      return false
    default:
      return false
    }
  }
}
