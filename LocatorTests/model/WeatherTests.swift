//
//  WeatherTests.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 19/01/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import XCTest
@testable import Locator

class WeatherTests: XCTestCase {

    func testClearDay() {
        let w = Weather.clearDay
        XCTAssertEqual("\u{f00d}", w.symbol)
        XCTAssertEqual(UIColor.clearDay, w.color)
        XCTAssertEqual(false, w.isDark)
    }

    func testClearNight() {
        let w = Weather.clearNight
        XCTAssertEqual("\u{f02e}", w.symbol)
        XCTAssertEqual(UIColor.clearNight, w.color)
        XCTAssertEqual(true, w.isDark)
    }

    func testCloudy() {
        let w = Weather.cloudy
        XCTAssertEqual("\u{f013}", w.symbol)
        XCTAssertEqual(UIColor.cloudy, w.color)
        XCTAssertEqual(false, w.isDark)
    }

    func testFog() {
        let w = Weather.fog
        XCTAssertEqual("\u{f014}", w.symbol)
        XCTAssertEqual(UIColor.fog, w.color)
        XCTAssertEqual(false, w.isDark)
    }

    func testHail() {
        let w = Weather.hail
        XCTAssertEqual("\u{f015}", w.symbol)
        XCTAssertEqual(UIColor.hail, w.color)
        XCTAssertEqual(false, w.isDark)
    }

    func testPartlyCloudyDay() {
        let w = Weather.partlyCloudyDay
        XCTAssertEqual("\u{f002}", w.symbol)
        XCTAssertEqual(UIColor.partlyCloudyDay, w.color)
        XCTAssertEqual(false, w.isDark)
    }

    func testPartlyCloudyNight() {
        let w = Weather.partlyCloudyNight
        XCTAssertEqual("\u{f086}", w.symbol)
        XCTAssertEqual(UIColor.partlyCloudyNight, w.color)
        XCTAssertEqual(true, w.isDark)
    }

    func testRain() {
        let w = Weather.rain
        XCTAssertEqual("\u{f019}", w.symbol)
        XCTAssertEqual(UIColor.rain, w.color)
        XCTAssertEqual(false, w.isDark)
    }

    func testRainDay() {
        let w = Weather.rainDay
        XCTAssertEqual("\u{f008}", w.symbol)
        XCTAssertEqual(UIColor.rainDay, w.color)
        XCTAssertEqual(false, w.isDark)
    }

    func testRainNight() {
        let w = Weather.rainNight
        XCTAssertEqual("\u{f028}", w.symbol)
        XCTAssertEqual(UIColor.rainNight, w.color)
        XCTAssertEqual(true, w.isDark)
    }

    func testSleet() {
        let w = Weather.sleet
        XCTAssertEqual("\u{f0b5}", w.symbol)
        XCTAssertEqual(UIColor.sleet, w.color)
        XCTAssertEqual(false, w.isDark)
    }

    func testSnow() {
        let w = Weather.snow
        XCTAssertEqual("\u{f01b}", w.symbol)
        XCTAssertEqual(UIColor.snow, w.color)
        XCTAssertEqual(false, w.isDark)
    }

    func testThunderstorm() {
        let w = Weather.thunderstorm
        XCTAssertEqual("\u{f01e}", w.symbol)
        XCTAssertEqual(UIColor.thunderstorm, w.color)
        XCTAssertEqual(false, w.isDark)
    }

    func testTornado() {
        let w = Weather.tornado
        XCTAssertEqual("\u{f056}", w.symbol)
        XCTAssertEqual(UIColor.tornado, w.color)
        XCTAssertEqual(false, w.isDark)
    }

    func testWind() {
        let w = Weather.wind
        XCTAssertEqual("\u{f050}", w.symbol)
        XCTAssertEqual(UIColor.wind, w.color)
        XCTAssertEqual(false, w.isDark)
    }

    // MARK: - Weather related objects.

    func testBarometer() {
        let w = Weather.barometer
        XCTAssertEqual("\u{f079}", w.symbol)
        XCTAssertEqual(UIColor.clear, w.color)
        XCTAssertEqual(false, w.isDark)
    }

    func testThermometer() {
        let w = Weather.thermometer
        XCTAssertEqual("\u{f055}", w.symbol)
        XCTAssertEqual(UIColor.clear, w.color)
        XCTAssertEqual(false, w.isDark)
    }

    func testThermometerInside() {
        let w = Weather.thermometerInside
        XCTAssertEqual("\u{f054}", w.symbol)
        XCTAssertEqual(UIColor.clear, w.color)
        XCTAssertEqual(false, w.isDark)
    }

    func testThermometerOutside() {
        let w = Weather.thermometerOutside
        XCTAssertEqual("\u{f053}", w.symbol)
        XCTAssertEqual(UIColor.clear, w.color)
        XCTAssertEqual(false, w.isDark)
    }

    func testWindCalm() {
        let w = Weather.windCalm
        XCTAssertEqual("\u{f0b7}", w.symbol)
        XCTAssertEqual(UIColor.clear, w.color)
        XCTAssertEqual(false, w.isDark)
    }

    func testWindDirection() {
        let w = Weather.windDirection
        XCTAssertEqual("\u{f0b1}", w.symbol)
        XCTAssertEqual(UIColor.clear, w.color)
        XCTAssertEqual(false, w.isDark)
    }

    func testNoWeatherDay() {
        let w = Weather.noWeatherDay
        XCTAssertEqual("\u{f095}", w.symbol)
        XCTAssertEqual(UIColor.noWeatherDay, w.color)
        XCTAssertEqual(false, w.isDark)
    }

    func testIconMatch() {
        XCTAssertEqual("\u{f00d}", Weather.representedBy(darkSkyIcon: "clear-day").symbol)
        XCTAssertEqual("\u{f02e}", Weather.representedBy(darkSkyIcon: "clear-night").symbol)
        XCTAssertEqual("\u{f019}", Weather.representedBy(darkSkyIcon: "rain").symbol)
        XCTAssertEqual("\u{f008}", Weather.representedBy(darkSkyIcon: "rain-day").symbol)
        XCTAssertEqual("\u{f01b}", Weather.representedBy(darkSkyIcon: "snow").symbol)
        XCTAssertEqual("\u{f0b5}", Weather.representedBy(darkSkyIcon: "sleet").symbol)
        XCTAssertEqual("\u{f050}", Weather.representedBy(darkSkyIcon: "wind").symbol)
        XCTAssertEqual("\u{f014}", Weather.representedBy(darkSkyIcon: "fog").symbol)
        XCTAssertEqual("\u{f013}", Weather.representedBy(darkSkyIcon: "cloudy").symbol)
        XCTAssertEqual("\u{f002}", Weather.representedBy(darkSkyIcon: "partly-cloudy-day").symbol)
        XCTAssertEqual("\u{f086}", Weather.representedBy(darkSkyIcon: "partly-cloudy-night").symbol)
        XCTAssertEqual("\u{f095}", Weather.representedBy(darkSkyIcon: "ANYTHING ELSE").symbol)
    }
}
