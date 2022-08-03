//
//  EIP1024Tests.swift
//  MEWwalletKitTests
//
//  Created by Nail Galiaskarov on 3/12/21.
//  Copyright © 2021 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import Quick
import Nimble
import MEWwalletTweetNacl
@testable import MEWwalletKit

class EIP1024Tests: QuickSpec {
    private let encryptedData = EthEncryptedData(
        nonce: "1dvWO7uOnBnO7iNDJ9kO9pTasLuKNlej",
        ephemPublicKey: "FBH1/pAEHOOW14Lu3FWkgV3qOEcuL78Zy+qW1RwzMXQ=",
        ciphertext: "f8kBcl/NCyf3sybfbwAKk/np2Bzt9lRVkZejr6uh5FgnNlH/ic62DZzy"
    )
    let recipientPrivateKeyString = "7e5374ec2ef0d91761a6e72fdf8f6ac665519bfdf6da0a2329cf0d804514b816"
    private let senderPrivateKey = try! PrivateKeyEth1(seed: Data(hex: "0xc55257c360c07c72029aebc1b53c05ed0362ada38ead3e3e9efa3708e53495531f09a6987599d18264c1e1c92f2cf141630c7a3c4ab7c81b2f001698e7463b04"), network: .ethereum)

    override func spec() {
        describe("salsa decryption") {
            it("should decrypt the encrypted data") {
                let message = try? self.encryptedData.decrypt(
                    privateKey: self.recipientPrivateKeyString //"7e5374ec2ef0d91761a6e72fdf8f6ac665519bfdf6da0a2329cf0d804514b816"
                )
                
                expect(message ?? "").to(equal("My name is Satoshi Buterin"))
            }
        }
        
        describe("test PrivateKeyEth1 extension") {
            it("should convert Ethereum keys to curve25519") {
                do {
                    let privateKey = Data([0x7e, 0x53, 0x74, 0xec, 0x2e, 0xf0, 0xd9, 0x17, 0x61, 0xa6, 0xe7, 0x2f, 0xdf, 0x8f, 0x6a, 0xc6, 0x65, 0x51, 0x9b, 0xfd, 0xf6, 0xda, 0x0a, 0x23, 0x29, 0xcf, 0x0d, 0x80, 0x45, 0x14, 0xb8, 0x16])
                    let ethPrivateKey = try PrivateKeyEth1(seed: privateKey, network: .ethereum)
                    let keypair = try TweetNacl.keyPair(fromSecretKey: ethPrivateKey.data())
                    
                    expect(keypair.secretKey.count) == 32
                    expect(keypair.publicKey.count) == 32
                    expect(String(data: keypair.publicKey.base64EncodedData(), encoding: .utf8)) == "uh9pcAr8Mg+nLj/8x4BPtMM9k925R8aXPAmjHjAV8x8="    
                } catch {
                    fail(error.localizedDescription)
                }
            }
        }
        
        describe("roundtrip") {
            it("should encrypt and then decrypt the data") {
                
                let recipientEthKey = PrivateKeyEth1(privateKey: Data(hex: self.recipientPrivateKeyString), network: .ethereum)
                expect(recipientEthKey.string()!) == "7e5374ec2ef0d91761a6e72fdf8f6ac665519bfdf6da0a2329cf0d804514b816"
                
                do {
                    let recipientKeyPair = try TweetNacl.keyPair(fromSecretKey: recipientEthKey.data())
                    guard let recipientPublicKeyString = String(data: recipientKeyPair.publicKey.base64EncodedData(), encoding: .utf8) else {
                        fail("returned nil")
                        return
                    }
                    
                    let encryptedData = try EthEncryptedData.encrypt(plaintext: "My name is Satoshi Buterin", senderPrivateKey: self.senderPrivateKey, recipientPublicKey: recipientPublicKeyString)
                    expect(Data(base64Encoded: encryptedData.ephemPublicKey)!.count) == 32
                    
                    
                    // Decrypt using recipient's private key string
                    let decryptedByRecipient = try encryptedData.decrypt(privateKey: recipientEthKey)
                    expect(decryptedByRecipient) == "My name is Satoshi Buterin"

                    // Decrypt using recipient's private key
                    let decryptedByRecipientString = try encryptedData.decrypt(privateKey: self.recipientPrivateKeyString)
                    expect(decryptedByRecipientString) == "My name is Satoshi Buterin"

                    // Decrypt using sender's private key
                    let decryptedBySender = try encryptedData.decrypt(senderPrivateKey: self.senderPrivateKey, recipientPublicKey: recipientPublicKeyString)
                    expect(decryptedBySender) == "My name is Satoshi Buterin"
                } catch {
                    fail(error.localizedDescription)
                }
            }
        }
    }
}
