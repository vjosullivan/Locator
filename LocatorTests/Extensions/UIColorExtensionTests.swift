//
//  UIColorExtensionTests.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 20/01/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import XCTest
@testable import Locator

class UIColorExtensionTests: XCTestCase {

    func testHexInit() {
        let c1 = UIColor(hexString: "#3F7FBF")
        let c2 = UIColor(hexString: "3F7FBF")

        let c1Components = c1.rgb()
        XCTAssertEqual(0x3F, Int(c1Components.red * 255))
        XCTAssertEqual(0x7F, Int(c1Components.green * 255))
        XCTAssertEqual(0xBF, Int(c1Components.blue * 255))
        let c2Components = c2.rgb()
        XCTAssertEqual(0x3F, Int(c2Components.red * 255))
        XCTAssertEqual(0x7F, Int(c2Components.green * 255))
        XCTAssertEqual(0xBF, Int(c2Components.blue * 255))
    }

    func testInvalidHex1() {
        let c1 = UIColor(hexString: "#3F7FBF000")

        let c1Components = c1.rgb()
        XCTAssertEqual(0, Int(c1Components.red * 255))
        XCTAssertEqual(0, Int(c1Components.green * 255))
        XCTAssertEqual(0, Int(c1Components.blue * 255))
    }

    func testInvalidHex2() {
        let c1 = UIColor(hexString: "#NOTHEX")

        let c1Components = c1.rgb()
        XCTAssertEqual(0, Int(c1Components.red * 255))
        XCTAssertEqual(0, Int(c1Components.green * 255))
        XCTAssertEqual(0, Int(c1Components.blue * 255))
    }

    func testLighten() {
        let c1 = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        let c2 = c1.lighter()
        let c2Components = c2.rgb()
        XCTAssertEqual(0.55, c2Components.red)
        XCTAssertEqual(0.55, c2Components.green)
        XCTAssertEqual(0.55, c2Components.blue)
        XCTAssertEqual(1.0, c2Components.alpha)
    }
}
