//
//  LocationTests.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 19/01/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import XCTest
@testable import Locator

class LocationTests: XCTestCase {

    func testCreatable() {
        let myPlace = JSONFixture(from: "good_location")!.dictionary!
        let location = Location(from: myPlace)
        XCTAssertNotNil(location)
        XCTAssertEqual(51.3, location?.latitude)
        XCTAssertEqual(-1.0, location?.longitude)
    }

    func testBadData() {
        let myPlace = JSONFixture(from: "bad_latitude")!.dictionary!
        let location = Location(from: myPlace)
        XCTAssertNil(location)
    }

    func testMissingData() {
        let myPlace = JSONFixture(from: "bad_longitude")!.dictionary!
        let location = Location(from: myPlace)
        XCTAssertNil(location)
    }
}
