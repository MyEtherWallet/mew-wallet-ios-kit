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
//        describe("encoding") {
//            it("should work for uint256") {
//                let types = convert(types: ["uint256"])
//                let values = [1]
//                
//                let a = abi.encode(types: types, values: values)
//                let b = "0000000000000000000000000000000000000000000000000000000000000001"
//            }
//            it("should work for uint") {
//              var a = abi.rawEncode(["uint"], [ 1 ]).toString('hex')
//              var b = "0000000000000000000000000000000000000000000000000000000000000001"
//            }
//            it("should work for int256") {
//              var a = abi.rawEncode([ 'int256' ], [ -1 ]).toString('hex')
//              var b = "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
//            }
//            it("should work for string and uint256[2]") {
//              var a = abi.rawEncode(['string', 'uint256[2]' ], [ 'foo', [5, 6] ]).toString('hex')
//              var b = """
//              0000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000500000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000003666f6f0000000000000000000000000000000000000000000000000000000000
//              """
//            }
//        }
    }

    private func convert(types: [String]) -> [ABI.Element.ParameterType] {
        return try! types.map {
            try! ABITypeParser.parseTypeString($0)
        }
    }
}
