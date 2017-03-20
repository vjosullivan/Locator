//
//  DarkMoonTests.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 19/01/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import XCTest
@testable import Locator

/// Icons are based on the "Awesome Weather" font set.
/// - see:
class DarkMoonTests: XCTestCase {

    private let newMoonIcon = "\u{F095}"
    private let newMoonIconAlt = "\u{F0EB}"
    private let moonFirstQuarterIcon = "\u{F09C}"
    private let moonFirstQuarterIconAlt = "\u{F0D6}"
    private let moonThirdQuarterIcon = "\u{F0AA}"
    private let moonThirdQuarterIconAlt = "\u{F0E4}"

    func testNewMoon() {
        XCTAssertEqual(newMoonIcon, DarkMoon.symbol(from: 0.0))
        XCTAssertEqual(newMoonIconAlt, DarkMoon.backgroundSymbol(from: 0.0))
        XCTAssertEqual("New\nmoon", DarkMoon.name(from: 0.0))
    }

    func testFirstQuarter() {
        XCTAssertEqual(moonFirstQuarterIcon, DarkMoon.symbol(from: 0.25))
        XCTAssertEqual(moonFirstQuarterIconAlt, DarkMoon.backgroundSymbol(from: 0.25))
        XCTAssertEqual("First\nquarter", DarkMoon.name(from: 0.25))
    }

    func testThirdQuarter() {
        XCTAssertEqual(moonThirdQuarterIcon, DarkMoon.symbol(from: 0.75))
        XCTAssertEqual(moonThirdQuarterIconAlt, DarkMoon.backgroundSymbol(from: 0.75))
        XCTAssertEqual("Last\nquarter", DarkMoon.name(from: 0.75))
    }
}
