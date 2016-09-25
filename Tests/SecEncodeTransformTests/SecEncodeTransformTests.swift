//
//  SecEncodeTransformTests.swift
//  Base32
//
//  Created by 野村 憲男 on 1/25/15.
//  Copyright (c) 2015 Norio Nomura. All rights reserved.
//

import Foundation
import XCTest
import Security
import Base32

let vectors: [(String, String, String)] = [
    ("", "", ""),
    ("f", "MY======", "CO======"),
    ("fo", "MZXQ====", "CPNG===="),
    ("foo", "MZXW6===", "CPNMU==="),
    ("foob", "MZXW6YQ=", "CPNMUOG="),
    ("fooba", "MZXW6YTB", "CPNMUOJ1"),
    ("foobar", "MZXW6YTBOI======", "CPNMUOJ1E8======"),
]

let convertedVectors = vectors.map {($0.data(using:.utf8)!, $1, $2)}

class SecEncodeTransformTests: XCTestCase {


    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // MARK: https://tools.ietf.org/html/rfc4648

    // MARK: Using SecEncodeTransform
    func test_RFC4648_Encode_UsingSecEncodeTransform() {
        #if os(macOS)
            var results = Array<String>(repeating: "", count: convertedVectors.count)
            let vectorsAndIndices = zip(convertedVectors, results.indices)
            self.measure{
                for _ in 0...100 {
                    for ((test, _, _), index) in vectorsAndIndices {
                        results[index] = TTTBase32EncodedString(from: test)!
                    }
                }
            }
            for ((test, expect, _), result) in zip(convertedVectors, results) {
                XCTAssertEqual(result, expect, "TTTBase32EncodedStringFromData for \(test)")
            }
        #else
            print("\(#function) is available on macOS")
        #endif
    }

    func test_RFC4648_Decode_UsingSecEncodeTransform() {
        #if os(macOS)
            var results = Array<Data>(repeating: Data(), count: convertedVectors.count)
            let vectorsAndIndices = zip(convertedVectors, results.indices)
            self.measure{
                for _ in 0...100 {
                    for ((_, test, _), index) in vectorsAndIndices {
                        results[index] = TTTData(fromBase32EncodedString: test)!
                    }
                }
            }
            for ((expect, test, _), result) in zip(convertedVectors, results) {
                XCTAssertEqual(result, expect, "TTTDataFromBase32EncodedString for \(test)")
            }
        #else
            print("\(#function) is available on macOS")
        #endif
    }

    // MARK: Using Base32
    func test_RFC4648_Encode_UsingBase32() {
        var results = Array<String>(repeating: "", count: convertedVectors.count)
        let vectorsAndIndices = zip(convertedVectors, results.indices)
        self.measure{
            for _ in 0...100 {
                for ((test, _, _), index) in vectorsAndIndices {
                    results[index] = base32Encode(test)
                }
            }
        }
        for ((test, expect, _), result) in zip(convertedVectors, results) {
            XCTAssertEqual(result, expect, "base32Encode for \(test)")
        }
    }

    func test_RFC4648_Decode_UsingBase32() {
        var results = Array<Data>(repeating: Data(), count: convertedVectors.count)
        let vectorsAndIndices = zip(convertedVectors, results.indices)
        self.measure{
            for _ in 0...100 {
                for ((_, test, _), index) in vectorsAndIndices {
                    results[index] = base32DecodeToData(test)!
                }
            }
        }
        for ((expect, test, _), result) in zip(convertedVectors, results) {
            XCTAssertEqual(result, expect, "base32Decode for \(test)")
        }
    }
}
