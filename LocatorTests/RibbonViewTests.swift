//
//  RibbonViewTests.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 20/01/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import XCTest
@testable import Locator

class RibbonViewTests: XCTestCase {

    func testInit() {
        let frame = CGRect(x: 100.0, y: 200.0, width: 300.0, height: 400.0)
        let ribbon = RibbonView(frame: frame)
        XCTAssertEqual(100.0, ribbon.frame.origin.x)
        XCTAssertEqual(200.0, ribbon.frame.origin.y)
        XCTAssertEqual(300.0, ribbon.frame.size.width)
        XCTAssertEqual(400.0, ribbon.frame.size.height)
    }

    /// - callout(Probably worth bearing in mind...):
    /// This test only exists to provide 100% code coverage on tests.
    /// It's highly doubtful that it does anything useful.
    func testDraw() {
        let frame = CGRect(x: 100.0, y: 200.0, width: 300.0, height: 400.0)
        let rect = CGRect(x: 500.0, y: 600.0, width: 700.0, height: 800.0)
        let ribbon = RibbonView(frame: frame)

        ribbon.draw(rect)
    }
}
