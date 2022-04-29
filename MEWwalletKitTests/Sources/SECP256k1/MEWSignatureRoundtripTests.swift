//
//  MEWSignatureRoundtripTests.swift
//  
//
//  Created by Ronald Mannak on 4/3/22.
//

import Foundation
import Quick
import Nimble
@testable
 import MEWwalletKit
import MEW_wallet_iOS_secp256k1_package

class MEWconnectSignatureRoundtripTests: QuickSpec {
    
  class TestVector {
    let privateKey: PrivateKeyEth1
    let address: Address
        
    init(_ privateKey: String, _ address: String) {
      self.privateKey = PrivateKeyEth1(privateKey: Data(hex: privateKey), network: .ethereum)
      self.address = Address(address: address)!
    }
  }

  lazy var testVectors: [TestVector] = { [
    TestVector("df02cbea58239744a8a6ba328056309ae43f86fec6db45e5f782adcf38aacadf", "0x83f1caAdaBeEC2945b73087F803d404F054Cc2B7"),
    TestVector("8a44657cf1937443831a3a9640229914a8fb8e18cfda34b604c5e78188fd6c17", "0xCF1D652DAb65ea4f10990FD2D2E59Cd7cbEb315a"),
    TestVector("66d3d76a0e5865c682019752ce1a79dda06ad92d8c9e938c0faddca411b227f4", "0xFF9e6Aec5b8F94d952A1A5d6847C59276b9CF50b"),
  ] }()

  lazy var messages: [String] = {[
    "Hello from MEW",
    "This is a test message",
    """
      Oh freddled gruntbuggly,
      Thy micturations are to me,
      As plurdled gabbleblotchits, in midsummer morning
      On a lurgid bee,
      That mordiously hath blurted out,
      Its earted jurtles, grumbling
      Into a rancid festering confectious organ squealer.
      Now the jurpling slayjid agrocrustles,
      Are slurping hagrilly up the axlegrurts,
      And living glupules frart and stipulate,
      Like jowling meated liverslime,
      Groop, I implore thee, my foonting turlingdromes,
      And hooptiously drangle me,
      With crinkly bindlewurdles, mashurbitries.
      Or else I shall rend thee in the gobberwarts with my blurglecruncheon,
      See if I don't!
    """,
  ]}()
  
  override func spec() {
    describe("signing and verification tests") {
      it("should match private keys and addresses") {
        for vector in self.testVectors {
          let derivedAddress = try vector.privateKey.publicKey().address()!
          expect(vector.address).to(equal(derivedAddress))
        }
      }
      it("should verify signatures") {
        for vector in self.testVectors {
          let derivedAddress = try vector.privateKey.publicKey().address()!
          expect(vector.address).to(equal(derivedAddress))

          for message in self.messages {
            let msgData = message.data(using: .utf8)!
            let signature = msgData.sign(key: vector.privateKey, leadingV: false)!
            let address = message.hashPersonalMessage()!.verify(signature: signature)
            expect(address).to(equal(vector.address))
          }
        }
      }
    }
  }
}



