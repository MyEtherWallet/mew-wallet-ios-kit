//
//  EIP155Tests.swift
//  MEWwalletKitTests
//
//  Created by Mikhail Nikanorov on 4/26/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

// swiftlint:disable identifier_name line_length force_try

import Foundation
import Quick
import BigInt
import Nimble
@testable import MEWwalletKit
import MEW_wallet_iOS_secp256k1_package

class EIP155Tests: QuickSpec {
  class TestVector {
    let id: Int
    let transaction: Transaction
    let signature: TransactionSignature
    let rlp: Data
    let sender: String?
    let hash: Data?

    init(id: Int, nonce: String, gasPrice: String, gasLimit: String, to: String, data: String, value: String, r: String, s: String, v: String, rlp: String, sender: String?, hash: String?, chainID: String?) {
      self.id = id
      if let chainID = chainID {
        //swiftlint:disable force_try
        self.transaction = try! LegacyTransaction(
          nonce: nonce,
          gasPrice: gasPrice,
          gasLimit: gasLimit,
          to: Address(raw: to),
          value: value,
          data: Data(hex: data),
          chainID: Data(hex: chainID)
        )
      } else {
        //swiftlint:disable force_try
        self.transaction = try! LegacyTransaction(
          nonce: nonce,
          gasPrice: gasPrice,
          gasLimit: gasLimit,
          to: Address(raw: to),
          value: value,
          data: Data(hex: data),
          chainID: nil
        )
      }

      self.signature = try! TransactionSignature(r: r, s: s, v: v)
      self.transaction.signature = self.signature
      self.rlp = Data(hex: rlp)
      self.sender = sender?.stringAddHexPrefix().lowercased()
      if let hash = hash {
        self.hash = Data(hex: hash)
      } else {
        self.hash = nil
      }
    }
  }

  lazy var testVectors: [TestVector] = {
    let vector: [TestVector] = [
      // EmptyTransaction.json
      TestVector(id: 0, nonce: "0", gasPrice: "0", gasLimit: "0", to: "0x095e7baea6a6c7c4c2dfeb977efac326af552d87", data: "", value: "0", r: "0x48b55bfa915ac795c431978d8a6a992b628d557da5ff759b307d495a36649353", s: "0xefffd310ac743f371de3b9f7f9cb56c0b28ad43601b4ab949f53faa07bd2c804", v: "0x1b", rlp: "0xf85d80808094095e7baea6a6c7c4c2dfeb977efac326af552d8780801ba048b55bfa915ac795c431978d8a6a992b628d557da5ff759b307d495a36649353a0efffd310ac743f371de3b9f7f9cb56c0b28ad43601b4ab949f53faa07bd2c804", sender: nil, hash: nil, chainID: nil),
      // RSsecp256k1.json
      TestVector(id: 1, nonce: "0x03", gasPrice: "0x01", gasLimit: "0x5208", to: "0xb94f5374fce5edbc8e2a8697c15331677e6ebf0b", data: "0x", value: "0x0a", r: "0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141", s: "0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141", v: "0x1c", rlp: "0xf85f030182520894b94f5374fce5edbc8e2a8697c15331677e6ebf0b0a801ca0fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141a0fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141", sender: nil, hash: nil, chainID: nil),
      // RightVRSTest.json
      TestVector(id: 2, nonce: "0x03", gasPrice: "0x01", gasLimit: "0x5208", to: "0xb94f5374fce5edbc8e2a8697c15331677e6ebf0b", data: "0x", value: "0x0a", r: "0x98ff921201554726367d2be8c804a7ff89ccf285ebc57dff8ae4c44b9c19ac4a", s: "0x1887321be575c8095f789dd4c743dfe42c1820f9231f98a962b210e3ac2452a3", v: "0x1c", rlp: "0xf85f030182520894b94f5374fce5edbc8e2a8697c15331677e6ebf0b0a801ca098ff921201554726367d2be8c804a7ff89ccf285ebc57dff8ae4c44b9c19ac4aa01887321be575c8095f789dd4c743dfe42c1820f9231f98a962b210e3ac2452a3", sender: "58d79230fc81a042315da7d243272798e27cb40c", hash: "1cbb233404f49e96cb795d0ea74f485eca2c41a216e0ce80694cef4dd7a45b50", chainID: nil),
      // SenderTest.json
      TestVector(id: 3, nonce: "0", gasPrice: "0x01", gasLimit: "0x5208", to: "0x095e7baea6a6c7c4c2dfeb977efac326af552d87", data: "", value: "0x0a", r: "0x48b55bfa915ac795c431978d8a6a992b628d557da5ff759b307d495a36649353", s: "0x1fffd310ac743f371de3b9f7f9cb56c0b28ad43601b4ab949f53faa07bd2c804", v: "0x1b", rlp: "0xf85f800182520894095e7baea6a6c7c4c2dfeb977efac326af552d870a801ba048b55bfa915ac795c431978d8a6a992b628d557da5ff759b307d495a36649353a01fffd310ac743f371de3b9f7f9cb56c0b28ad43601b4ab949f53faa07bd2c804", sender: "963f4a0d8a11b758de8d5b99ab4ac898d6438ea6", hash: "ecb3ece1b90ea15a2360b99abc98ae56bd6bec7d14d5ce16ca4e814b44e4438d", chainID: nil),
      // Vitalik_1.json
      TestVector(id: 4, nonce: "", gasPrice: "0x04a817c800", gasLimit: "0x5208", to: "0x3535353535353535353535353535353535353535", data: "", value: "", r: "0x044852b2a670ade5407e78fb2863c51de9fcb96542a07186fe3aeda6bb8a116d", s: "0x044852b2a670ade5407e78fb2863c51de9fcb96542a07186fe3aeda6bb8a116d", v: "0x25", rlp: "0xf864808504a817c800825208943535353535353535353535353535353535353535808025a0044852b2a670ade5407e78fb2863c51de9fcb96542a07186fe3aeda6bb8a116da0044852b2a670ade5407e78fb2863c51de9fcb96542a07186fe3aeda6bb8a116d", sender: "f0f6f18bca1b28cd68e4357452947e021241e9ce", hash: "b1e2188bc490908a78184e4818dca53684167507417fdb4c09c2d64d32a9896a", chainID: nil),
      // Vitalik_2.json
      TestVector(id: 5, nonce: "0x01", gasPrice: "0x04a817c801", gasLimit: "0xa410", to: "0x3535353535353535353535353535353535353535", data: "", value: "0x01", r: "0x489efdaa54c0f20c7adf612882df0950f5a951637e0307cdcb4c672f298b8bca", s: "0x489efdaa54c0f20c7adf612882df0950f5a951637e0307cdcb4c672f298b8bc6", v: "0x25", rlp: "0xf864018504a817c80182a410943535353535353535353535353535353535353535018025a0489efdaa54c0f20c7adf612882df0950f5a951637e0307cdcb4c672f298b8bcaa0489efdaa54c0f20c7adf612882df0950f5a951637e0307cdcb4c672f298b8bc6", sender: "23ef145a395ea3fa3deb533b8a9e1b4c6c25d112", hash: "e62703f43b6f10d42b520941898bf710ebb66dba9df81702702b6d9bf23fef1b", chainID: nil),
      // Vitalik_3.json
      TestVector(id: 6, nonce: "0x02", gasPrice: "0x04a817c802", gasLimit: "0xf618", to: "0x3535353535353535353535353535353535353535", data: "", value: "0x08", r: "0x2d7c5bef027816a800da1736444fb58a807ef4c9603b7848673f7e3a68eb14a5", s: "0x2d7c5bef027816a800da1736444fb58a807ef4c9603b7848673f7e3a68eb14a5", v: "0x25", rlp: "0xf864028504a817c80282f618943535353535353535353535353535353535353535088025a02d7c5bef027816a800da1736444fb58a807ef4c9603b7848673f7e3a68eb14a5a02d7c5bef027816a800da1736444fb58a807ef4c9603b7848673f7e3a68eb14a5", sender: "2e485e0c23b4c3c542628a5f672eeab0ad4888be", hash: "1f621d7d8804723ab6fec606e504cc893ad4fe4a545d45f499caaf16a61d86dd", chainID: nil),
      // Vitalik_4.json
      TestVector(id: 7, nonce: "0x03", gasPrice: "0x04a817c803", gasLimit: "0x014820", to: "0x3535353535353535353535353535353535353535", data: "", value: "0x1b", r: "0x2a80e1ef1d7842f27f2e6be0972bb708b9a135c38860dbe73c27c3486c34f4e0", s: "0x2a80e1ef1d7842f27f2e6be0972bb708b9a135c38860dbe73c27c3486c34f4de", v: "0x25", rlp: "0xf865038504a817c803830148209435353535353535353535353535353535353535351b8025a02a80e1ef1d7842f27f2e6be0972bb708b9a135c38860dbe73c27c3486c34f4e0a02a80e1ef1d7842f27f2e6be0972bb708b9a135c38860dbe73c27c3486c34f4de", sender: "82a88539669a3fd524d669e858935de5e5410cf0", hash: "99b6455776b1988840d0074c23772cb6b323eb32c5011e4a3a1d06d27b2eb425", chainID: nil),
      // Vitalik_5.json
      TestVector(id: 8, nonce: "0x04", gasPrice: "0x04a817c804", gasLimit: "0x019a28", to: "0x3535353535353535353535353535353535353535", data: "", value: "0x40", r: "0x13600b294191fc92924bb3ce4b969c1e7e2bab8f4c93c3fc6d0a51733df3c063", s: "0x13600b294191fc92924bb3ce4b969c1e7e2bab8f4c93c3fc6d0a51733df3c060", v: "0x25", rlp: "0xf865048504a817c80483019a28943535353535353535353535353535353535353535408025a013600b294191fc92924bb3ce4b969c1e7e2bab8f4c93c3fc6d0a51733df3c063a013600b294191fc92924bb3ce4b969c1e7e2bab8f4c93c3fc6d0a51733df3c060", sender: "f9358f2538fd5ccfeb848b64a96b743fcc930554", hash: "0b2b499d5a3e729bcc197e1a00f922d80890472299dd1c648988eb08b5b1ff0a", chainID: nil),
      // Vitalik_6.json + Vitalik_7.json
      TestVector(id: 9, nonce: "0x05", gasPrice: "0x04a817c805", gasLimit: "0x01ec30", to: "0x3535353535353535353535353535353535353535", data: "", value: "0x7d", r: "0x4eebf77a833b30520287ddd9478ff51abbdffa30aa90a8d655dba0e8a79ce0c1", s: "0x4eebf77a833b30520287ddd9478ff51abbdffa30aa90a8d655dba0e8a79ce0c1", v: "0x25", rlp: "0xf865058504a817c8058301ec309435353535353535353535353535353535353535357d8025a04eebf77a833b30520287ddd9478ff51abbdffa30aa90a8d655dba0e8a79ce0c1a04eebf77a833b30520287ddd9478ff51abbdffa30aa90a8d655dba0e8a79ce0c1", sender: "a8f7aba377317440bc5b26198a363ad22af1f3a4", hash: "99a214f26aaf2804d84367ac8f33ff74b3a94e68baf820668f3641819ced1216", chainID: nil),
      // Vitalik_8.json
      TestVector(id: 10, nonce: "0x06", gasPrice: "0x04a817c806", gasLimit: "0x023e38", to: "0x3535353535353535353535353535353535353535", data: "", value: "0xd8", r: "0x6455bf8ea6e7463a1046a0b52804526e119b4bf5136279614e0b1e8e296a4e2f", s: "0x6455bf8ea6e7463a1046a0b52804526e119b4bf5136279614e0b1e8e296a4e2d", v: "0x25", rlp: "0xf866068504a817c80683023e3894353535353535353535353535353535353535353581d88025a06455bf8ea6e7463a1046a0b52804526e119b4bf5136279614e0b1e8e296a4e2fa06455bf8ea6e7463a1046a0b52804526e119b4bf5136279614e0b1e8e296a4e2d", sender: "f1f571dc362a0e5b2696b8e775f8491d3e50de35", hash: "4ed0b4b20536cce62389c6b95ff6a517489b6045efdefeabb4ecf8707d99e15d", chainID: nil),
      // Vitalik_9.json
      TestVector(id: 11, nonce: "0x07", gasPrice: "0x04a817c807", gasLimit: "0x029040", to: "0x3535353535353535353535353535353535353535", data: "", value: "0x0157", r: "0x52f1a9b320cab38e5da8a8f97989383aab0a49165fc91c737310e4f7e9821021", s: "0x52f1a9b320cab38e5da8a8f97989383aab0a49165fc91c737310e4f7e9821021", v: "0x25", rlp: "0xf867078504a817c807830290409435353535353535353535353535353535353535358201578025a052f1a9b320cab38e5da8a8f97989383aab0a49165fc91c737310e4f7e9821021a052f1a9b320cab38e5da8a8f97989383aab0a49165fc91c737310e4f7e9821021", sender: "d37922162ab7cea97c97a87551ed02c9a38b7332", hash: "a40eb7000de852898a385a19312284bb06f6a9b5d8d03e0b8fb5df2f07f9fe94", chainID: nil),
      // Vitalik_10.json
      TestVector(id: 12, nonce: "0x08", gasPrice: "0x04a817c808", gasLimit: "0x02e248", to: "0x3535353535353535353535353535353535353535", data: "", value: "0x0200", r: "0x64b1702d9298fee62dfeccc57d322a463ad55ca201256d01f62b45b2e1c21c12", s: "0x64b1702d9298fee62dfeccc57d322a463ad55ca201256d01f62b45b2e1c21c10", v: "0x25", rlp: "0xf867088504a817c8088302e2489435353535353535353535353535353535353535358202008025a064b1702d9298fee62dfeccc57d322a463ad55ca201256d01f62b45b2e1c21c12a064b1702d9298fee62dfeccc57d322a463ad55ca201256d01f62b45b2e1c21c10", sender: "9bddad43f934d313c2b79ca28a432dd2b7281029", hash: "588df025c4c2d757d3e314bd3dfbfe352687324e6b8557ad1731585e96928aed", chainID: nil),
      // Vitalik_11.json
      TestVector(id: 13, nonce: "0x09", gasPrice: "0x04a817c809", gasLimit: "0x033450", to: "0x3535353535353535353535353535353535353535", data: "", value: "0x02d9", r: "0x52f8f61201b2b11a78d6e866abc9c3db2ae8631fa656bfe5cb53668255367afb", s: "0x52f8f61201b2b11a78d6e866abc9c3db2ae8631fa656bfe5cb53668255367afb", v: "0x25", rlp: "0xf867098504a817c809830334509435353535353535353535353535353535353535358202d98025a052f8f61201b2b11a78d6e866abc9c3db2ae8631fa656bfe5cb53668255367afba052f8f61201b2b11a78d6e866abc9c3db2ae8631fa656bfe5cb53668255367afb", sender: "3c24d7329e92f84f08556ceb6df1cdb0104ca49f", hash: "f39c7dac06a9f3abf09faf5e30439a349d3717611b3ed337cd52b0d192bc72da", chainID: nil),
      // Vitalik_12.json
      TestVector(id: 14, nonce: "0x0e", gasPrice: "", gasLimit: "0x0493e0", to: "", data: "0x60f2ff61000080610011600039610011565b6000f3", value: "", r: "0xa310f4d0b26207db76ba4e1e6e7cf1857ee3aa8559bcbc399a6b09bfea2d30b4", s: "0x6dff38c645a1486651a717ddf3daccb4fd9a630871ecea0758ddfcf2774f9bc6", v: "0x1c", rlp: "0xf8610e80830493e080809560f2ff61000080610011600039610011565b6000f31ca0a310f4d0b26207db76ba4e1e6e7cf1857ee3aa8559bcbc399a6b09bfea2d30b4a06dff38c645a1486651a717ddf3daccb4fd9a630871ecea0758ddfcf2774f9bc6", sender: "874b54a8bd152966d63f706bae1ffeb0411921e5", hash: "db38325f4c7a9917a611fd09694492c23b0ec357a68ab5cbf905fc9757b9919a", chainID: nil),
      // Vitalik_13.json
      TestVector(id: 15, nonce: "0x0f", gasPrice: "", gasLimit: "0x0493e0", to: "0x00000000000000000000000000000000000000c0", data: "0x646f6e6b6579", value: "", r: "0x9f00c6da4f2e4b5f3316e70c7669f9df71fa21d533afa63450065731132ba7b6", s: "0x3886c27a8b3515ab9e2e04492f8214718621421e92d3b6954d9e3fb409ead788", v: "0x1b", rlp: "0xf8660f80830493e09400000000000000000000000000000000000000c08086646f6e6b65791ba09f00c6da4f2e4b5f3316e70c7669f9df71fa21d533afa63450065731132ba7b6a03886c27a8b3515ab9e2e04492f8214718621421e92d3b6954d9e3fb409ead788", sender: "874b54a8bd152966d63f706bae1ffeb0411921e5", hash: "278608eba8465230d0552c8df9fbcc6fc35d2350f4feb0e49a399b2adab37e39", chainID: nil),
      // Vitalik_14.json
      TestVector(id: 16, nonce: "0x0f", gasPrice: "", gasLimit: "0x0493e0", to: "", data: "0x60f3ff61000080610011600039610011565b6000f3", value: "0x01", r: "0xaf2944b645e280a35789aacfce7e16a8d57b43a0076dfd564bdc0395e3576324", s: "0x5272a0013f198713128bb0e3da43bb03ec7224c5509d4cabbe39fd31c36b5786", v: "0x1b", rlp: "0xf8610f80830493e080019560f3ff61000080610011600039610011565b6000f31ba0af2944b645e280a35789aacfce7e16a8d57b43a0076dfd564bdc0395e3576324a05272a0013f198713128bb0e3da43bb03ec7224c5509d4cabbe39fd31c36b5786", sender: "874b54a8bd152966d63f706bae1ffeb0411921e5", hash: "d9a26fff8704b137b592b07b64a86eac555dc347c87ae7fe1d2fe824d12427e5", chainID: nil),
      // Vitalik_15.json
      TestVector(id: 17, nonce: "0x12", gasPrice: "", gasLimit: "0x0493e0", to: "0x0000000000000000000000000000000000000001", data: "0x6d6f6f7365", value: "0x00", r: "0x376d0277dd3a2a9229dbcb5530b532c7e4cb0f821e0ca27d9acb940970d500d8", s: "0x0ab2798f9d9c2f7551eb29d56878f8e342b45ca45f413b0fcba793d094f36f2b", v: "0x29", rlp: "0xf8651280830493e094000000000000000000000000000000000000000180856d6f6f736529a0376d0277dd3a2a9229dbcb5530b532c7e4cb0f821e0ca27d9acb940970d500d8a00ab2798f9d9c2f7551eb29d56878f8e342b45ca45f413b0fcba793d094f36f2b", sender: "3c24d7329e92f84f08556ceb6df1cdb0104ca49f", hash: nil, chainID: nil),
      // Vitalik_16.json
      TestVector(id: 18, nonce: "0x13", gasPrice: "", gasLimit: "0x0493e0", to: "0x0000000000000000000000000000000000000012", data: "0x6d6f6f7365", value: "0x00", r: "0xd0e340578f9d733986f6a55c5401953c90f7ccd46fe72d5588592dd9cbdf1e03", s: "0x01d8d63149bd986f363084ac064e8387850d80e5238cc16ed4d30fd0a5af7261", v: "0x2a", rlp: "0xf8651380830493e094000000000000000000000000000000000000001280856d6f6f73652aa0d0e340578f9d733986f6a55c5401953c90f7ccd46fe72d5588592dd9cbdf1e03a001d8d63149bd986f363084ac064e8387850d80e5238cc16ed4d30fd0a5af7261", sender: "3c24d7329e92f84f08556ceb6df1cdb0104ca49f", hash: nil, chainID: nil),
      // Vitalik_17.json
      TestVector(id: 19, nonce: "0x14", gasPrice: "", gasLimit: "0x0493e0", to: "0x0000000000000000000000000000000000000022", data: "0x6d6f6f7365", value: "0x00", r: "0x4bc84887af29d2b159ee290dee793bdba34079428f48699e9fc92a7e12d4aeaf", s: "0x63b9d78c5a36f96454fe2d5c1eb7c0264f6273afdc0ba28dd9a8f00eadaf7476", v: "0x2a", rlp: "0xf8651480830493e094000000000000000000000000000000000000002280856d6f6f73652aa04bc84887af29d2b159ee290dee793bdba34079428f48699e9fc92a7e12d4aeafa063b9d78c5a36f96454fe2d5c1eb7c0264f6273afdc0ba28dd9a8f00eadaf7476", sender: "3c24d7329e92f84f08556ceb6df1cdb0104ca49f", hash: nil, chainID: nil),
      // Custom chain Id
      TestVector(id: 21, nonce: "0x0", gasPrice: "0x6b49d200", gasLimit: "0x5208", to: "0x7fB1077e28b8C771330D323DBdC42E0623e05E3d", data: "", value: "0x0d6f37360172ac00", r: "0x5118e46bf62e2487f31d5a502c7223126ed3fa9366b95f862ff1c2b8ad598349", s: "0x73e67c4e27010dd728eecd8a6c7717552d20136369eacd0a6e0ba704aa2e1240", v: "0x9d", rlp: "0xf86c80846b49d200825208947fb1077e28b8c771330d323dbdc42e0623e05e3d880d6f37360172ac0080819da05118e46bf62e2487f31d5a502c7223126ed3fa9366b95f862ff1c2b8ad598349a073e67c4e27010dd728eecd8a6c7717552d20136369eacd0a6e0ba704aa2e1240", sender: "7fB1077e28b8C771330D323DBdC42E0623e05E3d", hash: "b02986ef811adcd1790a734c05918a614c7a160de567ae2ed5c353ef85e0c418", chainID: "61")
    ]
    return vector
  }()

  override func spec() {
    describe("Signature tests") {
      it("ttSignature tests") {
        for vector in self.testVectors {
          do {
            let transaction = vector.transaction
            expect(vector.rlp).to(equal(transaction.rlpEncode()), description: "Invalid RLP data. id: \(vector.id)")
            if vector.hash != nil {
              expect(vector.hash).to(equal(transaction.hash()), description: "Invalid hash. id: \(vector.id)")
              guard let context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN|SECP256K1_CONTEXT_VERIFY)) else {
                fail("Can't create context")
                return
              }
              defer { secp256k1_context_destroy(context) }
              guard let publicKeyData = transaction.signature?.recoverPublicKey(transaction: transaction, context: context) else {
                fail("Can't recover public key. id: \(vector.id)")
                continue
              }
              let publicKey = try PublicKeyEth1(publicKey: publicKeyData, index: 0, network: .ethereum)
              expect(publicKey.address()?.address).notTo(beNil())
              let lowercasedAddress = publicKey.address()?.address.lowercased()
              expect(vector.sender).to(equal(lowercasedAddress), description: "Invalid sender. id: \(vector.id)")
            }
          } catch {
            fail("Test failed because of exception: \(error)")
          }
        }
      }
      it("Should sign transaction and returns the expected signature") {
        let transaction = try? LegacyTransaction(nonce: "0x03", gasPrice: "0x3b9aca00", gasLimit: "0x7530",
                                           to: Address(raw: "0xb414031Aa4838A69e27Cb2AE31E709Bcd674F0Cb"), value: "0x64", data: Data([]))
        transaction?.chainID = BigInt(0x11)

        expect(transaction).toNot(beNil())
        expect(transaction?.hash()).to(equal(Data(hex: "0x91e0ad336c23d84f757aa4cde2d0bb557daf5e1ca0a0b850b6431f3277fc167b")))

        let privateKey = PrivateKeyEth1(privateKey: Data(hex: "3a0ce9a362c73439adb38c595e739539be1e34d19c5e9f04962c101c86bd7616"), network: .ethereum)
        do {
          try transaction?.sign(key: privateKey)
        } catch {
          fail("Test failed beacuse of exception: \(error)")
          return
        }

        expect(transaction?.signature).toNot(beNil())
        expect(transaction?.signature?.r.data.toHexString()).to(equal("1fff9fa845437523b0a7f334b7d2a0ab14364a3581f898cd1bba3b5909465867"))
        expect(transaction?.signature?.s.data.toHexString()).to(equal("1415137f53eeddf0687e966f8d59984676d6d92ce88140765ed343db6936679e"))
        expect(transaction?.signature?.v.data.toHexString()).to(equal("45"))
      }
      it("Should sign transaction and return the expected signature 2") {
        let transaction = try? LegacyTransaction(nonce: "0x00", gasPrice: "0x106", gasLimit: "0x33450",
                                           to: Address(raw: "0x5c5220918B616E583515A7F42b6bE0c967664462"), value: "0xc8", data: Data([]))
        expect(transaction?.serialize()?.toHexString()).to(equal("e08082010683033450945c5220918b616e583515a7f42b6be0c96766446281c880"))

        let privateKey = PrivateKeyEth1(privateKey: Data(hex: "009312d3c3a8ac6d00fb2df851e1cb0023becc00cc7a0083b0ae70f4bd0575ae"), network: .ethereum)
        expect(privateKey.address()?.address.lowercased()).to(equal("0x5c5220918b616e583515a7f42b6be0c967664462"))
        do {
          try transaction?.sign(key: privateKey)
        } catch {
          fail("Test failed beacuse of exception: \(error)")
          return
        }

        expect(transaction?.signature).toNot(beNil())
        expect(transaction?.signature?.r.data.toHexString()).to(equal("d87153e2fb484f21469785f5b6ab95cc5c3aba5a80487428b63024068633bda2"))
        expect(transaction?.signature?.s.data.toHexString()).to(equal("2421eb4be1a11ff6071881608f660047604a7f63883326588b4168a3491800"))
        expect(transaction?.signature?.v.data.toHexString()).to(equal("25"))
        expect(transaction?.serialize()?.toHexString()).to(equal("f8628082010683033450945c5220918b616e583515a7f42b6be0c96766446281c88025a0d87153e2fb484f21469785f5b6ab95cc5c3aba5a80487428b63024068633bda29f2421eb4be1a11ff6071881608f660047604a7f63883326588b4168a3491800"))
        expect(transaction?.hash()?.toHexString()).to(equal("a048f58d4da25b8d91c2691cd3527074ef4ac52f520cb63c40b1fe50a2abf906"))
      }
    }
  }
}
