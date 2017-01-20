//
//  DarkSkyUnitsTests.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 20/01/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import XCTest
@testable import Locator

class DarkSkyUnitsTests: XCTestCase {

    let usUnits = DarkSkyUnits.us
    let ukUnits = DarkSkyUnits.uk2
    let caUnits = DarkSkyUnits.ca
    let siUnits = DarkSkyUnits.si

    func testFrom() {
        XCTAssertEqual(DarkSkyUnits.si, DarkSkyUnits.units(from: "si"))
        XCTAssertEqual(DarkSkyUnits.ca, DarkSkyUnits.units(from: "ca"))
        XCTAssertEqual(DarkSkyUnits.uk2, DarkSkyUnits.units(from: "uk2"))
        XCTAssertEqual(DarkSkyUnits.us, DarkSkyUnits.units(from: "us"))
        XCTAssertEqual(DarkSkyUnits.auto, DarkSkyUnits.units(from: "other"))
    }

    func testTemperature() {
        XCTAssertEqual(UnitTemperature.celsius, siUnits.temperature)
        XCTAssertEqual(UnitTemperature.fahrenheit, usUnits.temperature)
    }

    func testAngle() {
        XCTAssertEqual(UnitAngle.degrees, siUnits.angle)
    }

    func testSpeed() {
        XCTAssertEqual(UnitSpeed.inchesPerHour, usUnits.rainIntensity)
        XCTAssertEqual(UnitSpeed.milesPerHour, usUnits.windSpeed)

        XCTAssertEqual(UnitSpeed.millimetersPerHour, caUnits.rainIntensity)
        XCTAssertEqual(UnitSpeed.kilometersPerHour, caUnits.windSpeed)

        XCTAssertEqual(UnitSpeed.millimetersPerHour, ukUnits.rainIntensity)
        XCTAssertEqual(UnitSpeed.milesPerHour, ukUnits.windSpeed)

        XCTAssertEqual(UnitSpeed.millimetersPerHour, siUnits.rainIntensity)
        XCTAssertEqual(UnitSpeed.metersPerSecond, siUnits.windSpeed)
    }

    func testAirPressure() {
        XCTAssertEqual(UnitPressure.inchesOfMercury, usUnits.airPressure)
        XCTAssertEqual(UnitPressure.hectopascals, ukUnits.airPressure)
        XCTAssertEqual(UnitPressure.hectopascals, caUnits.airPressure)
        XCTAssertEqual(UnitPressure.hectopascals, siUnits.airPressure)
    }

    func testDistance() {
        XCTAssertEqual(UnitLength.miles, usUnits.distance)
        XCTAssertEqual(UnitLength.miles, ukUnits.distance)
        XCTAssertEqual(UnitLength.kilometers, caUnits.distance)
        XCTAssertEqual(UnitLength.kilometers, siUnits.distance)
    }

    func testAccumulation() {
        XCTAssertEqual(UnitLength.inches, usUnits.accumulation)
        XCTAssertEqual(UnitLength.centimeters, ukUnits.accumulation)
        XCTAssertEqual(UnitLength.centimeters, caUnits.accumulation)
        XCTAssertEqual(UnitLength.centimeters, siUnits.accumulation)
    }
}
