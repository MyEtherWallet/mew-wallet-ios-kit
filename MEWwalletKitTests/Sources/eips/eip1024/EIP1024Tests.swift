//
//  EIP1024Tests.swift
//  MEWwalletKitTests
//
//  Created by Nail Galiaskarov on 3/12/21.
//  Copyright © 2021 MyEtherWallet Inc. All rights reserved.
//

import Foundation

import Foundation
import Quick
import Nimble
@testable import MEWwalletKit

class EIP1024Tests: QuickSpec {
    private let encryptedData = EthEncryptedData(
        nonce: "1dvWO7uOnBnO7iNDJ9kO9pTasLuKNlej",
        ephemPublicKey: "FBH1/pAEHOOW14Lu3FWkgV3qOEcuL78Zy+qW1RwzMXQ=",
        ciphertext: "f8kBcl/NCyf3sybfbwAKk/np2Bzt9lRVkZejr6uh5FgnNlH/ic62DZzy"
    )
    override func spec() {
        describe("salsa decryption") {
            it("should decrypt the encrypted data") {
                let message = try? self.encryptedData.decrypt(
                    privateKey: "7e5374ec2ef0d91761a6e72fdf8f6ac665519bfdf6da0a2329cf0d804514b816"
                )
                
                expect(message ?? "").to(equal("My name is Satoshi Buterin"))
            }
        }
    }
}
