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

    var namedPlace: Place = Place(name: "", region: "", placeID: "", latitude: 0.0, longitude: 0.0)
    var namelessPlace: Place = Place(name: "", region: "", placeID: "", latitude: 0.0, longitude: 0.0)

    override func setUp() {
        namedPlace = Place(name: placeName, region: region, placeID: placeID, latitude: latitude, longitude: longitude)
    }

    func testNamedPlace() {
        XCTAssertEqual(placeName, namedPlace.name)
        XCTAssertEqual(region, namedPlace.region)
        XCTAssertEqual(placeID, namedPlace.placeID)
        XCTAssertEqual(latitude, namedPlace.latitude)
        XCTAssertEqual(longitude, namedPlace.longitude)
    }

    func testNamelessPlace() {
        XCTAssertEqual("", namelessPlace.name)
        XCTAssertEqual("", namelessPlace.region)
        XCTAssertEqual("", namelessPlace.placeID)
        XCTAssertEqual(0.0, namelessPlace.latitude)
        XCTAssertEqual(0.0, namelessPlace.longitude)
    }

    func testEncoding1() {
        let path = NSTemporaryDirectory() as NSString
        let locToSave = path.appending("teststasks")
        // save your custom object in a file
        NSKeyedArchiver.archiveRootObject(namedPlace, toFile: locToSave)

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

    func testEncoding2() {
        let path = NSTemporaryDirectory() as NSString
        let locToSave = path.appending("teststasks")
        // save your custom object in a file
        NSKeyedArchiver.archiveRootObject(namelessPlace, toFile: locToSave)

        // load your custom object from the file
        if let temp = NSKeyedUnarchiver.unarchiveObject(withFile: locToSave) as? Place {
            XCTAssertEqual("", temp.name)
            XCTAssertEqual("", temp.region)
            XCTAssertEqual("", temp.placeID)
            XCTAssertEqual(0.0, temp.latitude)
            XCTAssertEqual(0.0, temp.longitude)
        } else {
            XCTFail()
        }
    }
}
