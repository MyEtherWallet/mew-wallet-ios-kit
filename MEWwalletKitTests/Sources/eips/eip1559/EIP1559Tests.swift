//
//  File.swift
//  
//
//  Created by Nail Galiaskarov on 6/8/21.
//

import Foundation

//
//  EIP1559Tests.swift
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

final class EIP1559Tests: QuickSpec {
  class TestVector {
    let id: Int
    let transaction: EIP1559Transaction
    let signedTransactionRLP: Data
    let signedHash: Data?
    let pk: Data

    init(
      id: Int,
      nonce: BigInt,
      value: BigInt,
      maxPriorityFeePerGas: BigInt,
      maxFeePerGas: BigInt,
      gasLimit: BigInt,
      to: String,
      accessList: [AccessList]? = nil,
      signedTransactionRLP: String,
      signedHash: String?,
      chainID: BigInt,
      pk: String
    ) {
      let privateKey = PrivateKeyEth1(privateKey: Data(hex: pk), network: .ethereum)

      self.id = id
      self.transaction = EIP1559Transaction(
        nonce: nonce,
        maxPriorityFeePerGas: maxPriorityFeePerGas,
        maxFeePerGas: maxFeePerGas,
        gasLimit: gasLimit,
        from: privateKey.address(),
        to: Address(raw: to),
        value: value,
        data: Data(),
        accessList: accessList,
        chainID: chainID
      )
      self.signedTransactionRLP = Data(hex: signedTransactionRLP)
      self.signedHash = signedHash.map { Data(hex: $0) }
      self.pk = Data(hex: pk)
    }
    
    init(
      id: Int,
      nonce: String,
      value: String,
      maxPriorityFeePerGas: String,
      maxFeePerGas: String,
      gasLimit: String,
      to: String,
      accessList: [AccessList]? = nil,
      signedTransactionRLP: String,
      signedHash: String?,
      chainID: Data,
      pk: String
    ) {
      let privateKey = PrivateKeyEth1(privateKey: Data(hex: pk), network: .ethereum)

      self.id = id
      self.transaction = try! EIP1559Transaction(
        nonce: nonce,
        maxPriorityFeePerGas: maxPriorityFeePerGas,
        maxFeePerGas: maxFeePerGas,
        gasLimit: gasLimit,
        from: privateKey.address(),
        to: Address(raw: to),
        value: value,
        data: Data(),
        accessList: accessList,
        chainID: chainID
      )
      self.signedTransactionRLP = Data(hex: signedTransactionRLP)
      self.signedHash = signedHash.map { Data(hex: $0) }
      self.pk = Data(hex: pk)
    }

  }

  lazy var testVectors: [TestVector] = {
    let vector: [TestVector] = [
      // https://github.com/ethereumjs/ethereumjs-monorepo/blob/ef29902092473b78bd79f80f68047d6f2c38c71b/packages/tx/test/json/eip1559.json
      .init(
        id: 0,
        nonce: BigInt(819),
        value: BigInt(43203529),
        maxPriorityFeePerGas: BigInt(75853),
        maxFeePerGas: BigInt(121212),
        gasLimit: BigInt(35552),
        to: "0x000000000000000000000000000000000000aaaa",
        signedTransactionRLP: "0xb87302f870821e8e8203338301284d8301d97c828ae094000000000000000000000000000000000000aaaa8402933bc980c080a0d067f2167008c59219652f91cbf8788dbca5f771f6e91e2b7657e85b78b472e0a01d305af9fe81fdba43f0dfcd400ed24dcace0a7e30d4e85701dcaaf484cd079e",
        signedHash: "0xa3bf78ff247cad934aa5fb13e05f11e59c93511523ff8a622e59c3a34700e5c8",
        chainID: BigInt(7822),
        pk: "0x8f2a55949038a9610f50fb23b5883af3b4ecb3c3bb792cbcefbd1542c692be63"
      ),
      .init(
        id: 1,
        nonce: BigInt(353),
        value: BigInt(61901619),
        maxPriorityFeePerGas: BigInt(38850),
        maxFeePerGas: BigInt(136295),
        gasLimit: BigInt(32593),
        to: "0x000000000000000000000000000000000000aaaa",
        signedTransactionRLP: "0xb87202f86f821e8e8201618297c283021467827f5194000000000000000000000000000000000000aaaa8403b08b3380c001a004205678f13fc1d7b10feea6513dfa76e24418b6e08097d95c6f93a3b64e536da01d45ad61bfece43862de2cce7d2575a8c1d08c26c87f3cb5f26d7b0be54a91b2",
        signedHash: nil,
        chainID: BigInt(7822),
        pk: "0x8f2a55949038a9610f50fb23b5883af3b4ecb3c3bb792cbcefbd1542c692be63"
      ),
      .init(
        id: 2,
        nonce: BigInt(985),
        value: BigInt(32531825),
        maxPriorityFeePerGas: BigInt(66377),
        maxFeePerGas: BigInt(136097),
        gasLimit: BigInt(68541),
        to: "0x000000000000000000000000000000000000aaaa",
        signedTransactionRLP: "0xb87402f871821e8e8203d983010349830213a183010bbd94000000000000000000000000000000000000aaaa8401f0657180c001a0e6d23c5ecc0f388a4d41a9523c3ad171e98083a61288c340b968dfe0903a6741a07319e8d54a4fd8f0c081d3ce093d869f9df598481991c8534bfd8f2c163884b4",
        signedHash: nil,
        chainID: BigInt(7822),
        pk: "0x8f2a55949038a9610f50fb23b5883af3b4ecb3c3bb792cbcefbd1542c692be63"
      ),
      .init(
        id: 3,
        nonce: BigInt(623),
        value: BigInt(21649799),
        maxPriorityFeePerGas: BigInt(74140),
        maxFeePerGas: BigInt(81173),
        gasLimit: BigInt(57725),
        to: "0x000000000000000000000000000000000000aaaa",
        signedTransactionRLP: "0xb87302f870821e8e82026f8301219c83013d1582e17d94000000000000000000000000000000000000aaaa84014a598780c080a0b107893e4590e177e244493a3f2b59d63619ddd82772105d8c96b7fc85ff683da07dc9b9dc054d2f69f9cc540688f6c0da3b54dd8bd8323f06d0ca26b546a480f1",
        signedHash: nil,
        chainID: BigInt(7822),
        pk: "0x8f2a55949038a9610f50fb23b5883af3b4ecb3c3bb792cbcefbd1542c692be63"
      ),
      .init(
        id: 4,
        nonce: BigInt(972),
        value: BigInt(94563383),
        maxPriorityFeePerGas: BigInt(42798),
        maxFeePerGas: BigInt(103466),
        gasLimit: BigInt(65254),
        to: "0x000000000000000000000000000000000000aaaa",
        signedTransactionRLP: "0xb87202f86f821e8e8203cc82a72e8301942a82fee694000000000000000000000000000000000000aaaa8405a2ec3780c080a02596bfedd3101f7e3c881eec060f83c60617fb21173ff41a560e02c9c23f02f4a01ef1f7930d31081c06dfd2176046a99442a88678638a33eb80afa8d2d3389ee0",
        signedHash: nil,
        chainID: BigInt(7822),
        pk: "0x8f2a55949038a9610f50fb23b5883af3b4ecb3c3bb792cbcefbd1542c692be63"
      ),
      .init(
        id: 5,
        nonce: BigInt(588),
        value: BigInt(99359647),
        maxPriorityFeePerGas: BigInt(87890),
        maxFeePerGas: BigInt(130273),
        gasLimit: BigInt(37274),
        to: "0x000000000000000000000000000000000000aaaa",
        signedTransactionRLP: "0xb87302f870821e8e82024c830157528301fce182919a94000000000000000000000000000000000000aaaa8405ec1b9f80c001a0404a06f2a9ba9d444e59f03e1b4ce46c4d7127342aa287a6e9a910b26ff6cc89a04af28549efdfb3e746938d01c92785e9852eb58c48d6f35cc99961e88f56603a",
        signedHash: nil,
        chainID: BigInt(7822),
        pk: "0x8f2a55949038a9610f50fb23b5883af3b4ecb3c3bb792cbcefbd1542c692be63"
      ),
      .init(
        id: 6,
        nonce: BigInt(900),
        value: BigInt(30402257),
        maxPriorityFeePerGas: BigInt(8714),
        maxFeePerGas: BigInt(112705),
        gasLimit: BigInt(76053),
        to: "0x000000000000000000000000000000000000aaaa",
        signedTransactionRLP: "0xb87302f870821e8e82038482220a8301b8418301291594000000000000000000000000000000000000aaaa8401cfe6d180c080a06e1bc9e4645de8bdad2c60424539c2dd93aacbc06ae94e440629b133a99e9ba7a03d23fdfdd9934c77fe5385a6b4b6c69e84cdec7814a19d81e648b5852ee5f7eb",
        signedHash: nil,
        chainID: BigInt(7822),
        pk: "0x8f2a55949038a9610f50fb23b5883af3b4ecb3c3bb792cbcefbd1542c692be63"
      ),
      .init(
        id: 7,
        nonce: BigInt(709),
        value: BigInt(6478043),
        maxPriorityFeePerGas: BigInt(86252),
        maxFeePerGas: BigInt(94636),
        gasLimit: BigInt(28335),
        to: "0x000000000000000000000000000000000000aaaa",
        signedTransactionRLP: "0xb87202f86f821e8e8202c5830150ec830171ac826eaf94000000000000000000000000000000000000aaaa8362d8db80c001a09880d133cd636f8c8dce32e2c43494b9f2dc000eee8dc61931e09f866ed04b46a00e44d5c503c7f08b36c8b062c32a963f3dd20a71e95e3d903bfbe7f4da47cd47",
        signedHash: nil,
        chainID: BigInt(7822),
        pk: "0x8f2a55949038a9610f50fb23b5883af3b4ecb3c3bb792cbcefbd1542c692be63"
      ),
      .init(
        id: 8,
        nonce: BigInt(939),
        value: BigInt(2782905),
        maxPriorityFeePerGas: BigInt(45216),
        maxFeePerGas: BigInt(91648),
        gasLimit: BigInt(45047),
        to: "0x000000000000000000000000000000000000aaaa",
        signedTransactionRLP: "0xb87102f86e821e8e8203ab82b0a08301660082aff794000000000000000000000000000000000000aaaa832a76b980c001a0a0e7d9b07c7ec68f24788a554f993b99d59a3f08439cc6c942f62ea0341f2aeba078122b9957c146f7c87811bd58a7e9916ca8c07dabcf875b97bbdef79cb9c197",
        signedHash: nil,
        chainID: BigInt(7822),
        pk: "0x8f2a55949038a9610f50fb23b5883af3b4ecb3c3bb792cbcefbd1542c692be63"
      ),
      .init(
        id: 9,
        nonce: BigInt(119),
        value: BigInt(65456115),
        maxPriorityFeePerGas: BigInt(24721),
        maxFeePerGas: BigInt(107729),
        gasLimit: BigInt(62341),
        to: "0x000000000000000000000000000000000000aaaa",
        signedTransactionRLP: "0xb87002f86d821e8e778260918301a4d182f38594000000000000000000000000000000000000aaaa8403e6c7f380c001a0e38e239770801eb995498c821e55ac9c19ae09184bb27b34be105e02fe3b7615a067c64ca6bd6d9107e85fd581ab2e70a14b637eb36505bb40861ef9d6e800cab6",
        signedHash: nil,
        chainID: BigInt(7822),
        pk: "0x8f2a55949038a9610f50fb23b5883af3b4ecb3c3bb792cbcefbd1542c692be63"
      ),
      .init(
        id: 10,
        nonce: "0x77",
        value: "0x3E6C7F3",
        maxPriorityFeePerGas: "0x6091",
        maxFeePerGas: "0x1A4D1",
        gasLimit: "0xF385",
        to: "0x000000000000000000000000000000000000aaaa",
        signedTransactionRLP: "0xb87002f86d821e8e778260918301a4d182f38594000000000000000000000000000000000000aaaa8403e6c7f380c001a0e38e239770801eb995498c821e55ac9c19ae09184bb27b34be105e02fe3b7615a067c64ca6bd6d9107e85fd581ab2e70a14b637eb36505bb40861ef9d6e800cab6",
        signedHash: nil,
        chainID: Data(hex: "0x1E8E"),
        pk: "0x8f2a55949038a9610f50fb23b5883af3b4ecb3c3bb792cbcefbd1542c692be63"
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
            
            try transaction.sign(key: privateKey)
            expect(transaction.signature).toNot(beNil())
            
            let serialized = transaction.serialize()!.rlpEncode()
            expect(serialized).to(equal(vector.signedTransactionRLP))

            let signedHash = transaction.hash(chainID: BigInt(7822), forSignature: false)
            if let expectedHash = vector.signedHash {
              expect(signedHash).to(equal(expectedHash))
            }
          } catch {
            fail("Test failed because of exception: \(error)")
          }
        }
      }
    }
    
    it("test real transaction") {
      do {
        let pk = PrivateKeyEth1(privateKey: Data(hex: "e3046226c9d5f6b7fda49b00123fe96ab2fac359315f27169b5c984059b3540f"), network: .ethereum)
        
        let transaction = try! EIP1559Transaction(
          nonce: "0x0",
          maxPriorityFeePerGas: "0x07",
          maxFeePerGas: "0x07",
          gasLimit: "0x5208",
          from: pk.address(),
          to: pk.address(),
          value: "0x16345785D8A0000",
          data: Data(),
          accessList: nil,
          chainID: Data(hex: "0x7b")
        )
        try transaction.sign(key: pk)
        let serialized = transaction.serialize()
        expect(serialized).to(equal(Data(hex: "02f86a7b8007078252089461fac28c810253ea3a42ebbb1a5cf8687765e4ee88016345785d8a000080c001a01f75fb4ae321bb55c0e7569d940ce133e775fb4494500ac6de9aeb16f45f20d1a05bf9b98c50422e3ada79a6920b1007bc36a1c36d178dbc1b44dfbd97fc56cf13")))
        
        let signedHash = transaction.hash(chainID: transaction.chainID, forSignature: false)
        expect(signedHash).to(equal(Data(hex: "be76a9ae424fe7a42da7db0f42db0ced82929710d9c19cfdaa7e18c634e6ae54")))
      } catch {
        fail("Test fail to sign the transaction")
      }
    }
    
    it("test real transaction with access list") {
      do {
        let pk = PrivateKeyEth1(privateKey: Data(hex: "e3046226c9d5f6b7fda49b00123fe96ab2fac359315f27169b5c984059b3540f"), network: .ethereum)
        
        let transaction = try! EIP1559Transaction(
          nonce: "0x01",
          maxPriorityFeePerGas: "0x07",
          maxFeePerGas: "0x07",
          gasLimit: "0x62d4",
          from: pk.address(),
          to: pk.address(),
          value: "0x16345785D8A0000",
          data: Data(),
          accessList: [.init(address: pk.address(), slots: [Data(hex: "0x0000000000000000000000000000000000000000000000000000000000000000")])],
          chainID: Data(hex: "0x7b")
        )
        try transaction.sign(key: pk)
        let serialized = transaction.serialize()
        expect(serialized).to(equal(Data(hex: "02f8a37b0107078262d49461fac28c810253ea3a42ebbb1a5cf8687765e4ee88016345785d8a000080f838f79461fac28c810253ea3a42ebbb1a5cf8687765e4eee1a0000000000000000000000000000000000000000000000000000000000000000001a0f76cef537ee6b5a2143e4ed62debc41c19e996365ceb8b7a9ec7d7db8f83c001a01fbe06e8a4e052015af13b985047925b9f97bf145c7e7adb96f051af7c2551f0")))
        
        let signedHash = transaction.hash(chainID: transaction.chainID, forSignature: false)
        expect(signedHash).to(equal(Data(hex: "0xc30b28761a4344c27f7ef7f5e3572c941111d32602a3c75e924f02fd6942bc04")))
      } catch {
        fail("Test fail to sign the transaction")
      }
    }
  }
}
