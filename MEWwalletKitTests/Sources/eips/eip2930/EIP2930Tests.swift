//
//  File.swift
//
//
//  Created by Nail Galiaskarov on 6/8/21.
//

import Foundation

//
//  EIP2930Tests.swift
//  MEWwalletKitTests
//
//

// swiftlint:disable identifier_name line_length force_try

import Foundation
import Quick
import BigInt
import Nimble
@testable import MEWwalletKit
import MEW_wallet_iOS_secp256k1_package

final class EIP2930Tests: QuickSpec {
  class TestVector {
    let id: Int
    let transaction: EIP2930Transaction
    let unsignedTransactionRLP: Data?
    let unsignedHash: Data?
    let signedTransactionRLP: Data?
    let signedHash: Data?
    let pk: Data

    init(
      id: Int,
      nonce: String,
      value: String,
      gasPrice: String,
      gasLimit: String,
      to: String,
      data: Data = Data(),
      accessList: [AccessList]? = nil,
      unsignedTransactionRLP: String? = nil,
      unsignedHash: String? = nil,
      signedTransactionRLP: String? = nil,
      signedHash: String? = nil,
      chainID: String,
      pk: String
    ) {
      let privateKey = PrivateKeyEth1(privateKey: Data(hex: pk), network: .ethereum)

      self.id = id
      self.transaction = try! EIP2930Transaction(
        nonce: nonce,
        gasPrice: gasPrice,
        gasLimit: gasLimit,
        from: privateKey.address(),
        to: Address(raw: to),
        value: value,
        data: data,
        accessList: accessList ?? [.empty],
        chainID: Data(hex: chainID)
      )
      self.unsignedTransactionRLP = unsignedTransactionRLP.map { Data(hex: $0) }
      self.unsignedHash = unsignedHash.map { Data(hex: $0) }

      self.signedTransactionRLP = signedTransactionRLP.map { Data(hex: $0) }
      self.signedHash = signedHash.map { Data(hex: $0) }
      self.pk = Data(hex: pk)
    }
  }

  lazy var testVectors: [TestVector] = {
    let vector: [TestVector] = [
      .init(
        id: 0,
        nonce: "0x00",
        value: "0x01",
        gasPrice: "0x3b9aca00",
        gasLimit: "0x62d4",
        to: "0xdf0a88b2b68c673713a8ec826003676f272e3573",
        accessList: [.init(address: Address(address: "0x0000000000000000000000000000000000001337"), slots: [Data(hex: "0x0000000000000000000000000000000000000000000000000000000000000000")])],
        signedTransactionRLP: "0x01f8a587796f6c6f76337880843b9aca008262d494df0a88b2b68c673713a8ec826003676f272e35730180f838f7940000000000000000000000000000000000001337e1a0000000000000000000000000000000000000000000000000000000000000000080a0294ac94077b35057971e6b4b06dfdf55a6fbed819133a6c1d31e187f1bca938da00be950468ba1c25a5cb50e9f6d8aa13c8cd21f24ba909402775b262ac76d374d",
        signedHash: "0xbbd570a3c6acc9bb7da0d5c0322fe4ea2a300db80226f7df4fef39b2d6649eec",
        chainID: "0x796f6c6f763378",
        pk: "0xfad9c8855b740a0b7ed4c221dbad0f33a83a49cad6b3fe8d5817ac83d38b6a19"
      ),
      .init(
        id: 1,
        nonce: "0x",
        value: "0x",
        gasPrice: "0x",
        gasLimit: "0x",
        to: "0x0101010101010101010101010101010101010101",
        data: Data(hex: "0x010200"),
        accessList: [.init(address: Address(address: "0x0101010101010101010101010101010101010101"), slots: [Data(hex: "0x0101010101010101010101010101010101010101010101010101010101010101")])],
        unsignedTransactionRLP: "0x01f858018080809401010101010101010101010101010101010101018083010200f838f7940101010101010101010101010101010101010101e1a00101010101010101010101010101010101010101010101010101010101010101",
        unsignedHash: "0x78528e2724aa359c58c13e43a7c467eb721ce8d410c2a12ee62943a3aaefb60b",
        chainID: "0x01",
        pk: "0x4646464646464646464646464646464646464646464646464646464646464646"
      )
    ]
    return vector
  }()

  override func spec() {
    describe("Signature tests") {
      it("Should sign transaction and returns the expected signature") {
        for vector in self.testVectors {
          do {
            let transaction = vector.transaction
            let privateKey = PrivateKeyEth1(privateKey: vector.pk, network: .ethereum)
            
            if let unsignedTransactionRLP = vector.unsignedTransactionRLP {
              expect(transaction.serialize()).to(equal(unsignedTransactionRLP))
            }
            
            if let unsignedHash = vector.unsignedHash {
              expect(transaction.hash(chainID: transaction.chainID, forSignature: true)).to(equal(unsignedHash))
            }
            
            try transaction.sign(key: privateKey)
            expect(transaction.signature).toNot(beNil())
            
            if let signedTransactionRLP = vector.signedTransactionRLP {
              let serialized = transaction.serialize()
              expect(serialized).to(equal(signedTransactionRLP))
            }

            let signedHash = transaction.hash(chainID: transaction.chainID!, forSignature: false)
            if let expectedHash = vector.signedHash {
              expect(signedHash).to(equal(expectedHash))
            }
          } catch {
            fail("Test failed because of exception: \(error)")
          }
        }
      }
    }
  }
}
