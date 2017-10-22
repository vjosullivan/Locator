//
//  SolarViewModelTests.swift
//  LocatorTests
//
//  Created by Vincent O'Sullivan on 21/10/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import XCTest
@testable import Locator

class SolarViewModelTests: XCTestCase {

    static let deviceTimeZone = TimeZone.current.identifier
    static let locationTimeZone = "Europe/Paris"
    static let invalidTimeZone = "Invalid/TimeZone"

    let beforeSunrise: TimeInterval = 1_509_171_767 // 1,800 seconds vefore sunrise.
    let sunrise: TimeInterval       = 1_509_173_567
    let beforeSunset: TimeInterval  = 1_509_207_249 // 900 seconds before sunset.
    let sunset: TimeInterval        = 1_509_208_149
    let afterSunset: TimeInterval   = 1_509_999_999

    static let noData: [String: AnyObject] = [
        "latitude":  51.3 as AnyObject,
        "longitude": -1.0 as AnyObject,
        "timezone":  deviceTimeZone as AnyObject,
        "flags":     ["units": "si"] as AnyObject]

    let noForecast = DarkSkyForecast(dictionary: noData)

    var forecastData: [String: AnyObject] = [:]
    var forecast: DarkSkyForecast?

    fileprivate func forecastData(timeZone: String) -> [String: AnyObject] {
        return [
            "latitude": 51.3 as AnyObject,
            "longitude": -1.0 as AnyObject,
            "timezone": timeZone as AnyObject,
            "daily": [
                "summary":"Rain.",
                "icon":"rain",
                "data":[[
                    "time":1509145200,
                    "summary":"More rain.",
                    "icon":"wind",
                    "sunriseTime": sunrise,
                    "sunsetTime": sunset,
                    "moonPhase": 0.5]]] as AnyObject,
            "flags":[
                "units":"uk2"] as AnyObject]
    }

    override func setUp() {
        forecast = DarkSkyForecast(dictionary: forecastData(timeZone: SolarViewModelTests.locationTimeZone))
    }

    override func tearDown() {
        forecastData = [:]
    }

    func testViewModelNoData() {

        let viewModel = SolarViewModel(with: noForecast!, time: SystemClock())

        XCTAssertEqual("No sunrise", viewModel.sunriseTimeAtLocation)
        XCTAssertEqual("", viewModel.sunriseTimeAtDevice)
        XCTAssertEqual(Weather.stars.symbol, viewModel.sunriseIcon)
        XCTAssertEqual(false, viewModel.sunHasRisenToday)
        XCTAssertEqual("No sunset", viewModel.sunsetTimeAtLocation)
        XCTAssertEqual("", viewModel.sunsetTimeAtDevice)
        XCTAssertEqual(Weather.stars.symbol, viewModel.sunsetIcon)
        XCTAssertEqual(false, viewModel.sunHasSetToday)
        XCTAssertEqual("", viewModel.timeToSunRiseOrSet)
        XCTAssertEqual("", viewModel.moonPhaseIcon)
        XCTAssertEqual("", viewModel.moonPhaseText)
    }

    func testSunData1() {

        let locationSunrise = Date(timeIntervalSince1970: sunrise).asHMZ(timeZone: SolarViewModelTests.locationTimeZone)
        let locationSunset  = Date(timeIntervalSince1970: sunset).asHMZ(timeZone: SolarViewModelTests.locationTimeZone)
        let deviceSunrise   = Date(timeIntervalSince1970: sunrise).asHMZ(timeZone: SolarViewModelTests.deviceTimeZone)
        let deviceSunset    = Date(timeIntervalSince1970: sunset).asHMZ(timeZone: SolarViewModelTests.deviceTimeZone)

        let viewModel = SolarViewModel(with: forecast!, time: SystemClock())

        XCTAssertEqual(locationSunrise, viewModel.sunriseTimeAtLocation)
        XCTAssertEqual(locationSunset, viewModel.sunsetTimeAtLocation)
        XCTAssertEqual(deviceSunrise, viewModel.sunriseTimeAtDevice)
        XCTAssertEqual(deviceSunset, viewModel.sunsetTimeAtDevice)
        XCTAssertEqual(Weather.sunrise.symbol, viewModel.sunriseIcon)
        XCTAssertEqual(Weather.sunset.symbol, viewModel.sunsetIcon)
    }

    func testSunHasNeitherRisenNorSet() {

        let viewModel = SolarViewModel(with: forecast!, time: MockClock(timeIntervalSince1970: beforeSunrise))

        XCTAssertFalse(viewModel.sunHasRisenToday)
        XCTAssertFalse(viewModel.sunHasRisenToday)
    }

    func testSunHasBothRisenAndSet() {
        let viewModel = SolarViewModel(with: forecast!, time: MockClock(timeIntervalSince1970: afterSunset))

        XCTAssertTrue(viewModel.sunHasRisenToday)
        XCTAssertTrue(viewModel.sunHasRisenToday)
        XCTAssertEqual("", viewModel.timeToSunRiseOrSet)
    }

    func testTimeToSunRise() {
        let viewModel = SolarViewModel(with: forecast!, time: MockClock(timeIntervalSince1970: beforeSunrise))

        XCTAssertEqual("Sunrise in 30 minutes.", viewModel.timeToSunRiseOrSet)
    }

    func testTimeToSunSet() {
        let viewModel = SolarViewModel(with: forecast!, time: MockClock(timeIntervalSince1970: beforeSunset))

        XCTAssertEqual("Sunset in 15 minutes.", viewModel.timeToSunRiseOrSet)
    }

    func testMoonPhase() {
        let viewModel = SolarViewModel(with: forecast!, time: MockClock(timeIntervalSince1970: beforeSunset))

        XCTAssertEqual("\u{F0A3}", viewModel.moonPhaseIcon)
        XCTAssertEqual("Full\nmoon", viewModel.moonPhaseText)
    }

    func testInvalidTimeZone() {

        let forecastWithBadTimeZone = forecastData(timeZone: SolarViewModelTests.invalidTimeZone)
        let badForecast = DarkSkyForecast(dictionary: forecastWithBadTimeZone)

        let viewModel = SolarViewModel(with: badForecast!, time: SystemClock())

        XCTAssertEqual("", viewModel.sunriseTimeAtLocation)
        XCTAssertEqual("", viewModel.sunsetTimeAtLocation)
        XCTAssertEqual(Weather.stars.symbol, viewModel.sunriseIcon)
        XCTAssertEqual(Weather.stars.symbol, viewModel.sunsetIcon)
    }

    func testDeviceInSameTimezoneAsLocation() {
        let forecastLocalLocn = forecastData(timeZone: TimeZone.current.identifier)
        let localForecast = DarkSkyForecast(dictionary: forecastLocalLocn)

        let viewModel = SolarViewModel(with: localForecast!, time: SystemClock())

        let locationSunrise = Date(timeIntervalSince1970: sunrise).asHMZ(timeZone: SolarViewModelTests.deviceTimeZone)
        let locationSunset  = Date(timeIntervalSince1970: sunset).asHMZ(timeZone: SolarViewModelTests.deviceTimeZone)

        XCTAssertEqual(locationSunrise, viewModel.sunriseTimeAtLocation)
        XCTAssertEqual(locationSunset, viewModel.sunsetTimeAtLocation)
        XCTAssertEqual("", viewModel.sunriseTimeAtDevice)
        XCTAssertEqual("", viewModel.sunsetTimeAtDevice)
    }
}
