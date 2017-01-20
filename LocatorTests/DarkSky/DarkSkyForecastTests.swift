//
//  DarkSkyForecastTests.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 20/01/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import XCTest
@testable import Locator

class DarkSkyForecastTests: XCTestCase {

    private var dataPoint = [String: AnyObject]()
    private var forecast = [String: AnyObject]()

    override func setUp() {
        dataPoint = [
            "summary": "test" as AnyObject,
            "icon": "test" as AnyObject,
            "data": [["time": 1_400_000_000.0 as AnyObject, "temperature": 12.4 as AnyObject]] as AnyObject
        ]
        forecast = [
            "latitude": 51.3 as AnyObject,
            "longitude": -1.0 as AnyObject,
            "timezone": "Europe/London" as AnyObject,
          //  "daily": dataDictionary as AnyObject,
            "flags": ["units": "si"] as AnyObject
        ]
    }
    func testCreatable() {
        forecast["daily"] = dataPoint as AnyObject
        let dsf = DarkSkyForecast(dictionary: forecast as [String : AnyObject])!
        XCTAssertEqual(12.4, dsf.today?.temperature?.value)
        XCTAssertEqual(1, dsf.daily?.dataPoints?.count)
    }

    func testCurrently() {
        forecast["currently"] = ["time": 1_400_000_000.0 as AnyObject, "temperature": 12.4 as AnyObject] as AnyObject
        let dsf = DarkSkyForecast(dictionary: forecast as [String : AnyObject])!
        XCTAssertEqual(12.4, dsf.current?.temperature?.value)
    }

    func testMissingTimestamp() {
        // Supply no timestamps in the data...
        dataPoint = [
            "summary": "test" as AnyObject,
            "icon": "test" as AnyObject,
            "data": [["NO_time": 1_400_000_000.0 as AnyObject, "temperature": 12.4 as AnyObject]] as AnyObject
        ]
        forecast["daily"] = dataPoint as AnyObject
        let dsf = DarkSkyForecast(dictionary: forecast as [String : AnyObject])!

        // Assert that no daily forecasts exist because none were supplied with timestamps.
        XCTAssertEqual(0, dsf.daily?.dataPoints?.count)
    }
}
