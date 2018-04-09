//
//  DataPointCodableViewModel.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 08/04/2018.
//  Copyright © 2018 Vincent O'Sullivan. All rights reserved.
//

import UIKit

struct DataPointCodableViewModel {

    // MARK: - Private properties

    private let dataPoint: DataPointCodable?
    private let timeZone: String
    private let units: String

    // MARK: - Public properties

    public var summary: String {
        return dataPoint?.summary ?? ""
    }

    public var sunrise: String {
        return dataPoint?.sunriseTime?.asHMZ(timeZone: timeZone) ?? "No sunrise"
    }

    public var sunriseDeviceTimezone: String {
        return dataPoint?.sunriseTime?.asHMZ(timeZone: TimeZone.current.identifier) ?? ""
    }

    public var sunset: String {
        return dataPoint?.sunsetTime?.asHMZ(timeZone: timeZone) ?? "No sunset"
    }

    public var sunsetDeviceTimezone: String {
        return dataPoint?.sunsetTime?.asHMZ(timeZone: TimeZone.current.identifier) ?? ""
    }

    public var temperature: String {
        if let temperature = dataPoint?.apparentTemperature {
            return "\(Int(round(temperature)))\(temperatureSymbol(units: units))"
        } else {
            return ""
        }
    }

    public var weatherSymbol: String {
        return Weather.representedBy(darkSkyIcon: dataPoint?.icon ?? "").symbol
    }

    public var weatherSymbolColor: UIColor {
        return Weather.representedBy(darkSkyIcon: dataPoint?.icon ?? "").color
    }

    // MARK: - Initializers
    
    init(dataPoint: DataPointCodable?, timeZone: String, units: String) {
        self.dataPoint = dataPoint
        self.timeZone  = timeZone
        self.units     = units
    }

    // MARK: - Private functions

    private func temperatureSymbol(units: String) -> String {
        switch units {
        case "si", "ca", "uk2":
            return UnitTemperature.celsius.symbol
        default:
            return UnitTemperature.fahrenheit.symbol
        }
    }
}
