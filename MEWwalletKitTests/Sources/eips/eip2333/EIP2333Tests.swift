//
//  EIP2333Tests.swift
//  MEWwalletKitTests
//
//  Created by Mikhail Nikanorov on 12/7/20.
//  Copyright © 2020 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MEWwalletKit

class EIP2333Tests: QuickSpec {
  struct TestVector {
    let seed: String
    let masterSK: String
    let derivationPath: String
    let childSK: String
    let childSKHex: String
  }
  
  struct PublicKeyTestVector {
    let seed: String
    let derivationPath: String
    let publicKey: String
  }
  
  // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-2333.md
  lazy var testVectors: [TestVector] = {
    let vector: [TestVector] = [
      TestVector(seed: "0xc55257c360c07c72029aebc1b53c05ed0362ada38ead3e3e9efa3708e53495531f09a6987599d18264c1e1c92f2cf141630c7a3c4ab7c81b2f001698e7463b04",
                 masterSK: "6083874454709270928345386274498605044986640685124978867557563392430687146096",
                 derivationPath: "m/0",
                 childSK: "20397789859736650942317412262472558107875392172444076792671091975210932703118",
                 childSKHex: "2d18bd6c14e6d15bf8b5085c9b74f3daae3b03cc2014770a599d8c1539e50f8e"),
      TestVector(seed: "0x3141592653589793238462643383279502884197169399375105820974944592",
                 masterSK: "29757020647961307431480504535336562678282505419141012933316116377660817309383",
                 derivationPath: "m/3141592653",
                 childSK: "25457201688850691947727629385191704516744796114925897962676248250929345014287",
                 childSKHex: "384843fad5f3d777ea39de3e47a8f999ae91f89e42bffa993d91d9782d152a0f"),
      TestVector(seed: "0x0099FF991111002299DD7744EE3355BBDD8844115566CC55663355668888CC00",
                 masterSK: "27580842291869792442942448775674722299803720648445448686099262467207037398656",
                 derivationPath: "m/4294967295",
                 childSK: "29358610794459428860402234341874281240803786294062035874021252734817515685787",
                 childSKHex: "40e86285582f35b28821340f6a53b448588efa575bc4d88c32ef8567b8d9479b"),
      TestVector(seed: "0xd4e56740f876aef8c010b86a40d5f56745a118d0906a34e69aec8c0db1cb8fa3",
                 masterSK: "19022158461524446591288038168518313374041767046816487870552872741050760015818",
                 derivationPath: "m/42",
                 childSK: "31372231650479070279774297061823572166496564838472787488249775572789064611981",
                 childSKHex: "455c0dc9fccb3395825d92a60d2672d69416be1c2578a87a7a3d3ced11ebb88d"),
      TestVector(seed: "0xb1d2d33674c04b178d4bcdbcc18659a03bcdc2ab5c189b1ad46c7dec7a322e63ed2f9e71dd958a2dda71489e747785e553aeba07f020f8972cbaa4529e0be1f6",
                 masterSK: "20622391184523430372800738928649485045191877345701887243502519409331883080447",
                 derivationPath: "m/0",
                 childSK: "218965949329162110697650570671281069433295889839523449548870205706469257026",
                 childSKHex: "007bee2a75dea2715aa35bfe5b572a75613c86d1d849de8553b282bb0b4e2f42")
    ]
    return vector
  }()
  
  lazy var publicKeyTestVectors: [PublicKeyTestVector] = {
    let vector: [PublicKeyTestVector] = [
      PublicKeyTestVector(seed: "0xb1d2d33674c04b178d4bcdbcc18659a03bcdc2ab5c189b1ad46c7dec7a322e63ed2f9e71dd958a2dda71489e747785e553aeba07f020f8972cbaa4529e0be1f6",
                          derivationPath: "m/0",
                          publicKey: "90a978fdcd88e5f74a0169dad60e04fff304072b1b25a4801fb6c9d699367fa76dc88c672727af2e6bdc20b9ee82c990"),
      PublicKeyTestVector(seed: "0xb1d2d33674c04b178d4bcdbcc18659a03bcdc2ab5c189b1ad46c7dec7a322e63ed2f9e71dd958a2dda71489e747785e553aeba07f020f8972cbaa4529e0be1f6",
                          derivationPath: "m/12381/3600/2/10000",
                          publicKey: "b8546c5936984c6f7e4255242eb538a5b2bf6579bf84825fd51d3bf3e965f95db9a63acbff6ce47cf59b3c4ad5bc5d0e"),
      PublicKeyTestVector(seed: "0x79e842ee702d3d30a22be674896ed778b11d059b6101fc15251ded0fd152c3f31c41c2821d1a4dbc0f879bf1ebe54337e43e74ec20891522fb6921b3641e6cdf",
                          derivationPath: "m/0",
                          publicKey: "895f737259fc6dfb34893afbbab3dc3c92eaaeb38397138df2f27616dbf58c49af027380b71977b7a611604f4fcb591f"),
      PublicKeyTestVector(seed: "0x90e3e63a59ba4aed2837d1c96de49b34f82ab2ffe91f95d32633fe916beca492d3893232374b9dd0d38f10df5ba01ec2926db2c2b6b2f15ae244952185549d2a",
                          derivationPath: "m/0",
                          publicKey: "87e6ad2eb8b5308c9a01a56b8d9bf9e63d6027c299df534c0280da31a59fa1a9f9c5b1b7c3ba7b6a64541fc00f9fe63d"),
      PublicKeyTestVector(seed: "0x4aac06445eec80f6e2d0bf57d9860565acb30c67b1c73698779f9a90faa1e8b437731b50db930de7646944f264d5c6d09d00ce47524c96699bdd69d93cb1b71a",
                          derivationPath: "m/0",
                          publicKey: "91bd584043a4b64b9446c6d64fb657febedcbb1d6f6520d85a2776ef688f8f72312086e823651eed1b1db955c4d438d5"),
      PublicKeyTestVector(seed: "0x55e2e6d3f8d7482769497c3a1331d37d9a9235e4c717e9681febc0337d95a0ac11a6c253c984644d739fbd3602c981acca8faa347543ad7d4e2de942841e7a2f",
                          derivationPath: "m/0",
                          publicKey: "b25f21ce7267912a635ad0dfcee266dfccfd778cf1e6d679d5302e295a966ca56675faefbfbaf5f83b616e9339c4e1e3")
    ]
    return vector
  }()
  
  override func spec() {
    describe("EIP2333 test") {
      describe("Should pass all test vectors. Count: \(self.testVectors.count)") {
        for (idx, vector) in self.testVectors.enumerated() {
          it("Should pass test vector - \(idx)") {
            do {
              let seedData = Data(hex: vector.seed)
              let wallet = try Wallet<SecretKeyEth2>(seed: seedData)
              let masterSKdata = wallet.privateKey.data()
              guard let masterSK = MEWBigInt<UInt8>(masterSKdata.toHexString(), radix: 16) else {
                fail("Can't get masterSK")
                return
              }
              let masterSKDecimal = masterSK.decimalString
              expect(masterSKDecimal).to(equal(vector.masterSK))

              let derivedWallet = try wallet.derive(vector.derivationPath)
              let childSKdata = derivedWallet.privateKey.data()
              debugPrint(childSKdata.toHexString())
              guard let childSK = MEWBigInt<UInt8>(childSKdata.toHexString(), radix: 16) else {
                fail("Can't get childSK")
                return
              }
              let childSKDecimal = childSK.decimalString
              expect(childSKDecimal).to(equal(vector.childSK))
              expect(childSKdata.toHexString().lowercased()).to(equal(vector.childSKHex.lowercased()))
            } catch {
              fail("Test failed because of exception: \(error)")
            }
          }
        }
      }
    }
    describe("EIP2333 Withdrawal key tests") {
      describe("Should pass all test vectors. Count: \(self.testVectors.count)") {
        for (idx, vector) in self.publicKeyTestVectors.enumerated() {
          it("Should pass test vector - \(idx)") {
            do {
              let seedData = Data(hex: vector.seed)
              let wallet = try Wallet<SecretKeyEth2>(seed: seedData)
              let derivedWallet = try wallet.derive(vector.derivationPath)
              let masterSKdata = derivedWallet.privateKey.data()
              let secretKey = try SecretKeyEth2(privateKey: masterSKdata)
              let publicKey = secretKey.publicKey()?.data()
              expect(publicKey?.toHexString().lowercased()).to(equal(vector.publicKey))
            } catch {
              fail("Test failed because of exception: \(error)")
            }
          }
        }
      }
    }
  }
}
