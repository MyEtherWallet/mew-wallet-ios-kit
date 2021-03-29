//
//  File.swift
//  
//
//  Created by Nail Galiaskarov on 3/24/21.
//

import Foundation


import CryptoSwift
import Foundation
import Quick
import Nimble
@testable import MEWwalletKit

private typealias abi = ABIEncoder

final class ABITests: QuickSpec {
    override func spec() {
        describe("abi encoding") {
            it("should work for uint256") {
                let types = self.convert(types: ["uint256"])
                let values = [1] as [AnyObject]
                
                let a = abi.encode(types: types, values: values)!.toHexString()
                let b = "0000000000000000000000000000000000000000000000000000000000000001"
                
                expect(a).to(equal(b))
            }
            it("should work for uint") {
                ///
                /// uint = uint256
                ///  int = int256
                ///
                
                let types = self.convert(types: ["uint"])
                let values = [1] as [AnyObject]
                let a = abi.encode(types: types, values: values)!.toHexString()
                let b = "0000000000000000000000000000000000000000000000000000000000000001"
                expect(a).to(equal(b))
            }
            it("should work for int256") {
                let types = self.convert(types: ["int256"])
                let values = [-1] as [AnyObject]

                let a = abi.encode(types: types, values: values)!.toHexString()
                let b = "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
                expect(a).to(equal(b))
            }
            it("should work for string and uint256[2]") {
                let types = self.convert(types: ["string", "uint256[2]"])
                let values = ["foo", [5, 6]] as [AnyObject]
                let a = abi.encode(types: types, values: values)!.toHexString()
                let b = """
              0000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000500000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000003666f6f0000000000000000000000000000000000000000000000000000000000
              """
                expect(a).to(equal(b))
            }
            it("should work for int8") {
                let types = self.convert(types: ["int8"])
                let values = [1] as [AnyObject]
                let a = abi.encode(types: types, values: values)!.toHexString()
                let b = "0000000000000000000000000000000000000000000000000000000000000001"
                expect(a).to(equal(b))
            }
            it("should work for address with prefix") {
                let types = self.convert(types: ["address"])
                let values = ["0xb52a783858f2d1c4972590c9ce1d96f412ac95ab" as NSString]
                
                let a = abi.encode(types: types, values: values)!.toHexString()
                let b = "000000000000000000000000b52a783858f2d1c4972590c9ce1d96f412ac95ab"
                expect(a).to(equal(b))
            }
            it("should work for address without prefix") {
                let types = self.convert(types: ["address"])
                let values = ["b52a783858f2d1c4972590c9ce1d96f412ac95ab" as NSString]
                
                let a = abi.encode(types: types, values: values)!.toHexString()
                let b = "000000000000000000000000b52a783858f2d1c4972590c9ce1d96f412ac95ab"
                expect(a).to(equal(b))
            }
        }
    }

    private func convert(types: [String]) -> [ABI.Element.ParameterType] {
        return try! types.map {
            try! ABITypeParser.parseTypeString($0)
        }
    }
}
