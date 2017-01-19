//
//  DarkMoonTests.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 19/01/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import XCTest
@testable import Locator

class DarkMoonTests: XCTestCase {

    func testNewMoon() {
        XCTAssertEqual("\u{f095}", DarkMoon.symbol(from: 0.0))
        XCTAssertEqual("\u{f0EB}", DarkMoon.backgroundSymbol(from: 0.0))
        XCTAssertEqual("New\nmoon", DarkMoon.name(from: 0.0))
    }

    func testFirstQuarter() {
        XCTAssertEqual("\u{f09C}", DarkMoon.symbol(from: 0.25))
        XCTAssertEqual("\u{f0D6}", DarkMoon.backgroundSymbol(from: 0.25))
        XCTAssertEqual("First\nquarter", DarkMoon.name(from: 0.25))
    }

    func testThirdQuarter() {
        XCTAssertEqual("\u{f0AA}", DarkMoon.symbol(from: 0.75))
        XCTAssertEqual("\u{f0E4}", DarkMoon.backgroundSymbol(from: 0.75))
        XCTAssertEqual("Last\nquarter", DarkMoon.name(from: 0.75))
    }
}
