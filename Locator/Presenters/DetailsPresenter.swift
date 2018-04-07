//
//  DetailsPresenter.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 01/01/2018.
//  Copyright © 2018 Vincent O'Sullivan. All rights reserved.
//

import Foundation

class DetailsPresenter {

    // MARK: - Local constants and variables.

    private let forecast: DarkSkyForecast
    private let clock: Clock

    // MARK: - Public functions.

    init(forecast: DarkSkyForecast, clock: Clock) {
        self.forecast = forecast
        self.clock = clock
    }

    public func viewCreated(view: DetailsView) {
        let minData = formatTemperatureData(prefix: "Low",
                                            temperature: forecast.today?.temperatureLow,
                                            time: forecast.today?.temperatureLowTime,
                                            timeZone: forecast.timeZone)
        view.minimum(temperature: minData.temperatureText, time: minData.timeText, highlight: minData.highlight)
        let maxData = formatTemperatureData(prefix: "High",
                                            temperature: forecast.today?.temperatureHigh,
                                            time: forecast.today?.temperatureHighTime,
                                            timeZone: forecast.timeZone)
        view.maximum(temperature: maxData.temperatureText, time: maxData.timeText, highlight: maxData.highlight)

        view.summary(forecast.hourly?.summary ?? "")

        if let pressure = format(pressure: forecast.current?.pressure) {
            view.pressure(pressure, label: "Pressure", symbol: Weather.barometer.symbol)
        } else {
            view.pressure("", label: "No pressure", symbol: "")
        }

        if let humidity = format(humidity: forecast.current?.humidity) {
            view.humidity(humidity, label: "Humidity", symbol: Weather.humidity.symbol)
        } else {
            view.humidity("", label: "No humidity", symbol: "")
        }

        if let windSpeed = forecast.current?.windSpeed, let bearing = forecast.current?.windBearing?.value {
            view.wind(windSpeed.description, degrees: bearing, label: "Wind", symbol: Weather.windDirection.symbol)
        } else {
            view.wind("", degrees: 0.0, label: "", symbol: "")
        }
    }

    // MARK: - Private functions.

    /// Returns displayable data for the today's minimum or maximum temperature.
    ///
    /// - Parameters:
    ///   - prefix: Displayable prefix (e.g. "Low" or "High").
    ///   - temperature: A temperature measurement.
    ///   - time: The time at which the temperature is expected.
    /// - Returns: Displayable temperature/time data.
    ///
    private func formatTemperatureData(prefix: String,
                                       temperature: Measurement<UnitTemperature>?,
                                       time: Date?,
                                       timeZone: String) -> (temperatureText: String, timeText: String, highlight: Bool) {
        guard let temperature = temperature else {
            return (temperatureText: "", timeText: "", highlight: false)
        }

        let temperatureText = "\(prefix) \(Int(temperature.value))\(temperature.unit.symbol)"
        let timeText: String
        let highlight: Bool
        if let time = time {
            timeText = "@ \(time.asHHMM(timezone: timeZone))"
            // Set highlight on for future dates.
            highlight = time.isAfter(SystemClock().currentDateTime)
        } else {
            timeText = ""
            highlight = false
        }

        return (temperatureText: temperatureText, timeText: timeText, highlight: highlight)
    }

    /// Returns the pressure measurement as a displayable `String`.
    ///
    /// - Parameter measurement: An air pressure measurement.
    ///
    private func format(pressure: Measurement<UnitPressure>?) -> String? {
        guard let pressure = pressure else {
            return nil
        }
        let pressureValue: String
        switch pressure.unit {
        case UnitPressure.inchesOfMercury:
            pressureValue = String(Double(Int(pressure.value * 100)) / 100.0)
        case UnitPressure.kilopascals:
            pressureValue = String(Double(Int(pressure.value * 10)) / 10.0)
        default:
            pressureValue = String(Int(pressure.value))
        }
        return "\(pressureValue) \(pressure.unit.symbol)"
    }

    /// Returns the humidity data as a displayable `String`.
    ///
    /// - Parameter value: Relative humidity value in range 0 to 1.
    ///
    private func format(humidity: Double?) -> String? {
        guard let humidity = humidity else { return nil }

        return "\(Int(humidity * 100))%"
    }

    private func format(windSpeed: Measurement<UnitSpeed>?) -> String? {
        guard let speed = windSpeed else { return nil }

        return speed.description
    }

    /// Updates the wind direction display from the supplied measurement.
    ///
    /// - Parameter measurement: A wind direction measurement.
    ///
    private func format(windDirection: Measurement<UnitAngle>?) -> String? {
        guard let direction = windDirection else { return nil }

        return "from \(cardinal(from: direction.value))"
    }

    private func cardinal(from degrees: Double) -> String {
        switch degrees {
        case 0...22.5:
            return "north"
        case 22.5...67.5:
            return "north-east"
        case 67.5...112.5:
            return "east"
        case 112.5...157.5:
            return "south-east"
        case 157.5...202.5:
            return "south"
        case 202.5...247.5:
            return "south-west"
        case 247.5...292.5:
            return "west"
        case 292.5...337.5:
            return "north-west"
        case 337.5...360.0:
            return "north"
        default:
            return "somewhere"
        }
    }
}
