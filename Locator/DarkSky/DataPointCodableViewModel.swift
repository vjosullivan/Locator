//
//  DataPointCodableViewModel.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 08/04/2018.
//  Copyright © 2018 Vincent O'Sullivan. All rights reserved.
//

import UIKit

struct DataPointCodableViewModel {

    // MARK: - Base properties

    private let dataPoint: DataPointCodable?
    public  let timeZone: String
    private let units: String

    // MARK: - Public properties

    public var moonIcon: String {
        if let phase = dataPoint?.moonPhase {
            return DarkMoon.symbol(from: phase)
        } else {
            return ""
        }
    }

    public var moonText: String {
        if let phase = dataPoint?.moonPhase {
            return DarkMoon.name(from: phase)
        } else {
            return ""
        }
    }

    public var summary: String {
        return dataPoint?.summary ?? ""
    }

    public var sunrise: String {
        return dataPoint?.sunriseTime?.asHMZ(timeZone: timeZone) ?? "No sunrise"
    }

    public var sunriseHasOccurred: Bool {
        return SystemClock().currentDateTime.isAfter(dataPoint?.sunriseTime ?? Date.distantFuture)
    }

    public var sunsetHasOccurred: Bool {
        return SystemClock().currentDateTime.isAfter(dataPoint?.sunsetTime ?? Date.distantFuture)
    }

    public var sunriseIcon: String {
        return dataPoint?.sunriseTime == nil ? Weather.stars.symbol : Weather.sunrise.symbol
    }

    public var sunriseUsingDeviceTimezone: String {
        return dataPoint?.sunriseTime?.asHMZ(timeZone: TimeZone.current.identifier) ?? ""
    }

    public var sunset: String {
        return dataPoint?.sunsetTime?.asHMZ(timeZone: timeZone) ?? "No sunset"
    }

    public var sunsetIcon: String {
        return dataPoint?.sunsetTime == nil ? Weather.stars.symbol : Weather.sunset.symbol
    }

    public var sunsetUsingDeviceTimezone: String {
        return dataPoint?.sunsetTime?.asHMZ(timeZone: TimeZone.current.identifier) ?? ""
    }

    public var temperature: String {
        return formatted(temperature: dataPoint?.apparentTemperature)
    }

    public var temperatureHigh: String {
        return formatted(temperature: dataPoint?.apparentTemperatureHigh)
    }

    public var temperatureLow: String {
        return formatted(temperature: dataPoint?.apparentTemperatureLow)
    }

    public var timeToNextSunRiseOrSet: String {
        guard let sunrise = dataPoint?.sunriseTime, let sunset = dataPoint?.sunsetTime else {
            return ""
        }
        let now = SystemClock().currentDateTime
        if sunrise.isAfter(now) && (sunset.isAfter(sunrise) || now.isAfter(sunset)) {
            return timeToEvent(called: "Sunrise", at: sunrise, from: now)
        }
        if sunset.isAfter(now) && (sunrise.isAfter(sunset) || now.isAfter(sunrise)) {
            return timeToEvent(called: "Sunset", at: sunset, from: now)
        }
        return ""
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

    private func formatted(temperature: Double?) -> String {
        guard let temperature = temperature else {
            return ""
        }
        return "\(Int(round(temperature)))\(temperatureSymbol(units: units))"
    }

    private func temperatureSymbol(units: String) -> String {
        switch units {
        case "si", "ca", "uk2":
            return UnitTemperature.celsius.symbol
        default:
            return UnitTemperature.fahrenheit.symbol
        }
    }

    /// Return a longhand description of the time remaining until the named event occurs.
    ///
    /// - Parameters:
    ///   - name: The name of the event (e.g. "Sunrise")
    ///   - time: The date of the occurrence of the event.
    ///           If the date is not a future date, an empty `String` is returned.
    /// - Returns: A longhand description of the time remaining to the named event.
    ///
    private func timeToEvent(called name: String, at time: Date, from now: Date) -> String {
        guard time.isAfter(now) else {
            return ""
        }
        let minutes = Int(time.timeIntervalSince(now) / 60.0)
        if minutes < 60 {
            let plural = minutes == 1 ? "" : "s"
            return "\(name) in \(minutes) minute\(plural)."
        }
        var hours = minutes / 60
        let preposition: String
        switch (minutes % 60) {
        case 1...5:
            preposition = "About"
        case 6...15:
            preposition = "Just over"
        case 16...30:
            preposition = "Over"
        case 31...55:
            preposition = "Under"
            hours += 1
        case 56...59:
            preposition = "Just under"
            hours += 1
        default:
            preposition = "almost exactly"
        }
        let plural = hours == 1 ? "" : "s"

        return "\(preposition) \(hours) hour\(plural) to \(name)."
    }
}
