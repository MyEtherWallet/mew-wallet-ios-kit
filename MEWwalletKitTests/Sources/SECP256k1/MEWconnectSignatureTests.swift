//
//  MEWconnectSignatureTests.swift
//  MEWwalletKitTests
//
//  Created by Mikhail Nikanorov on 7/24/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MEWwalletKit
import MEW_wallet_iOS_secp256k1_package

class MEWconnectSignatureTests: QuickSpec {
  override func spec() {
    describe("MEWconnect signature test") {
      it("should sign personal message data correctly") {
        let testMessage = Data([0xe2, 0x45, 0x10, 0x93, 0x83, 0xa4, 0x80, 0xc0, 0x86, 0x80, 0x18, 0xca, 0x92, 0x8c, 0xbe, 0xd5, 0x77, 0x21, 0x39, 0xa4, 0x31, 0x04, 0x7f, 0xef,
                                0xb5, 0xc5, 0xf0, 0x46, 0x59, 0x24, 0x65, 0x75])
        let testPrivateKey = Data([0x41, 0xd1, 0xc8, 0xf0, 0xd3, 0x78, 0x1e, 0x50, 0xf8, 0x49, 0x96, 0xfc, 0x65, 0x5e, 0xe5, 0x64, 0x98, 0x2a, 0x88, 0xbe, 0x8d, 0xa4, 0x95, 0x2d,
                                   0x9e, 0xdd, 0xb5, 0x16, 0xdb, 0x06, 0xd5, 0x88])
        let testRecoverableSignature = Data([0x35, 0x38, 0x1f, 0x1e, 0x79, 0x6d, 0x53, 0xf4, 0x60, 0x47, 0xce, 0xfc, 0x8d, 0x40, 0x0b, 0xb2, 0xac, 0x51, 0x7e, 0xcf, 0xde, 0x9b,
                                             0xb0, 0xab, 0x1f, 0x84, 0x59, 0x22, 0x84, 0xf3, 0x08, 0x31, 0x02, 0xca, 0x22, 0xb8, 0xfb, 0x2c, 0xe0, 0x54, 0x82, 0x01, 0x9d, 0xf0,
                                             0x2c, 0xa9, 0xfc, 0x65, 0x26, 0x53, 0xdd, 0x07, 0xb5, 0xbe, 0xdb, 0x8c, 0x48, 0x86, 0x24, 0x1a, 0x86, 0x77, 0xdd, 0x41, 0x01])
        let testSerializedRecoverableSignature = Data([0x31, 0x08, 0xf3, 0x84, 0x22, 0x59, 0x84, 0x1f, 0xab, 0xb0, 0x9b, 0xde, 0xcf, 0x7e, 0x51, 0xac, 0xb2, 0x0b, 0x40, 0x8d, 0xfc,
                                                       0xce, 0x47, 0x60, 0xf4, 0x53, 0x6d, 0x79, 0x1e, 0x1f, 0x38, 0x35, 0x41, 0xdd, 0x77, 0x86, 0x1a, 0x24, 0x86, 0x48, 0x8c, 0xdb,
                                                       0xbe, 0xb5, 0x07, 0xdd, 0x53, 0x26, 0x65, 0xfc, 0xa9, 0x2c, 0xf0, 0x9d, 0x01, 0x82, 0x54, 0xe0, 0x2c, 0xfb, 0xb8, 0x22, 0xca,
                                                       0x02, 0x01])
        
        guard let context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN)) else {
          fail("Can't create secp256k1 context")
          return
        }
        defer { secp256k1_context_destroy(context) }
        
        var recoverableSignature = testMessage.secp256k1RecoverableSign(privateKey: testPrivateKey, context: context)
        guard let recoverableSignatureData = recoverableSignature?.data() else {
          fail("Can't get signature data")
          return
        }
        expect(testRecoverableSignature) == recoverableSignatureData
        
        guard let serializedRecoverableSignature = recoverableSignature?.serialized(context: context) else {
          fail("Can't serialize signature")
          return
        }
        expect(testSerializedRecoverableSignature) == serializedRecoverableSignature
      }
      
      it("Should sign data correctly") {
        let testData = "064701b9218c1a1893d8ef7e33f45afa11d4bf986fa7f815e8b23a2dc8b4d89b".hashPersonalMessage()!
        let testKey = Data(hex: "064701b9218c1a1893d8ef7e33f45afa11d4bf986fa7f815e8b23a2dc8b4d89b")
        
        let testResultLeadingV = Data(hex: "1c5cb544567bd07a5ec818908c076307d18dbfd6ae83ef324fc818d0d20ee359723d74a80bca59358994d2cacdcb6102826b9631dbf69ee092c9341c7d273bcf1d")
        let testResultTrailingV = Data(hex: "5cb544567bd07a5ec818908c076307d18dbfd6ae83ef324fc818d0d20ee359723d74a80bca59358994d2cacdcb6102826b9631dbf69ee092c9341c7d273bcf1d1c")
        
        guard let signedDataLeadingV = testData.sign(key: testKey, leadingV: true), let signedDataTrailingV = testData.sign(key: testKey, leadingV: false)
        else {
          fail("Can't get signed data")
          return
        }
        
        expect(signedDataLeadingV) == testResultLeadingV
        expect(signedDataTrailingV) == testResultTrailingV
      }
      it("Should have correct length") {
        let testKey = Data(hex: "064701b9218c1a1893d8ef7e33f45afa11d4bf986fa7f815e8b23a2dc8b4d89b")
        let data = "476020729".hashPersonalMessage()
        let signature = data?.sign(key: testKey, leadingV: false)
        
        let correctSignature = Data(hex: "cb739fd04d52879de00721dcdf62ba32a79c8d8bf39c8802fb9d7154b41b2d15003ac8f68b4b1e5394831dc9ced7350bde2776024888558e1d6fe07d4f7d12f71c")
        expect(signature) == correctSignature
        expect(signature?.count) == 65
      }
      
      it("Should multiply EC correctly") {
        let testPrivateKey = Data(hex: "db391b235fc493cbcab9f5d2ed9582036606b946b8685995db4a17df2b87e2a2")
        let testPublicKey = Data(hex: "04669a833ba477e4b2136c7fd6778247a688f4d9de6da9e9de92d3637a4a674f55af8d29a13b5e2b81db6aece5726dc7a0b4d99fe09f7335e54dab9ee012aa0c45")
        let testMultiplied = Data(hex: "0449be3b4c5e49732f9fd57111f3a9e7e2100856337de980302877a061defc02593e6a92ad1ca153ab95cba05736754814240a7b3579cabaf3fb29b8d5d1b05340")
        
        let multiData = testPublicKey.secp256k1Multiply(privateKey: testPrivateKey)
        
        expect(multiData) == testMultiplied
      }
    }
  }
}
