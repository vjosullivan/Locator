//
//  String_extensionTests.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 19/01/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import XCTest
@testable import Locator

class StringExtensionTests: XCTestCase {

    func testSubstringFrom() {
        XCTAssertEqual("cde", "abcde".substring(from: 2))
    }

    func testSubstringTo() {
        XCTAssertEqual("ab", "abcde".substring(to: 2))
        XCTAssertEqual("abcd", "abcde".substring(to: 4))
    }

    func testSubstringRange() {
        XCTAssertEqual("cd", "abcde".substring(2..<4))
    }
}
