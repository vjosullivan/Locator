//
//  CreditsViewControllerTests.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 27/03/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import XCTest
@testable import Locator

class CreditsViewControllerTests: XCTestCase {

    private var creditsVC: CreditsViewController?

    private let dataPoint = [
        "summary": "test" as AnyObject,
        "icon": "test" as AnyObject,
        "data": [["time": 1_400_000_000.0 as AnyObject, "temperature": 12.4 as AnyObject]] as AnyObject
        ]
    private let forecast = [
            "latitude": 51.3 as AnyObject,
            "longitude": -1.0 as AnyObject,
            "timezone": "Europe/London" as AnyObject,
            //  "daily": dataDictionary as AnyObject,
            "flags": ["units": "si"] as AnyObject
        ]
    private var darkSkyForecast: DarkSkyForecast?

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        creditsVC = storyboard.instantiateViewController(withIdentifier: "CreditsViewController")
            as? CreditsViewController

        darkSkyForecast = DarkSkyForecast(dictionary: forecast)
    }

    override func tearDown() {
        creditsVC = nil

        super.tearDown()
    }

    func testNotNil() {
        XCTAssertNotNil(creditsVC)
    }

    func testColours() {
        creditsVC?.update(forecast: darkSkyForecast!, backgroundColor: UIColor.green, cornerRadius: 8.0)

        XCTAssertEqual(UIColor.blue, creditsVC?.returnButton.currentTitleShadowColor)
    }
}
