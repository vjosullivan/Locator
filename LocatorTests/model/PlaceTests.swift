//
//  PlaceTests.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 13/11/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import XCTest
@testable import Locator

class PlaceTests: XCTestCase {

    let placeName = "London"
    let region = "England"
    let placeID = "XYZ"
    let latitude = 51.5
    let longitude = -0.5

    var place: Place = Place(name: "", region: "", placeID: "", latitude: 0.0, longitude: 0.0)

    override static func setUp() {
        print("\n\nStart tests...")
    }

    override func setUp() {
        place = Place(name: placeName, region: region, placeID: placeID, latitude: latitude, longitude: longitude)
    }

    override static func tearDown() {
        print("Tests completed\n\n")
    }

    func testCreatable() {
        XCTAssertEqual(placeName, place.name)
        XCTAssertEqual(region, place.region)
        XCTAssertEqual(placeID, place.placeID)
        XCTAssertEqual(latitude, place.latitude)
        XCTAssertEqual(longitude, place.longitude)
    }

    func testEncoding() {
        let path = NSTemporaryDirectory() as NSString
        let locToSave = path.appending("teststasks")
        // save your custom object in a file
        NSKeyedArchiver.archiveRootObject(place, toFile: locToSave)

        // load your custom object from the file
        if let temp = NSKeyedUnarchiver.unarchiveObject(withFile: locToSave) as? Place {
            XCTAssertEqual(placeName, temp.name)
            XCTAssertEqual(region, temp.region)
            XCTAssertEqual(placeID, temp.placeID)
            XCTAssertEqual(latitude, temp.latitude)
            XCTAssertEqual(longitude, temp.longitude)
        } else {
            XCTFail()
        }
    }
}
