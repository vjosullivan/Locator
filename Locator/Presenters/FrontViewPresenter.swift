//
//  File.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 22/04/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import Foundation

class FrontViewPresenter {

    private enum MinMaxType: String {
        case minimum = "Low"
        case maximum = "High"
    }

    private let forecast: DarkSkyForecast
    private let clock: Clock
    private var view: FrontView?

    init(forecast: DarkSkyForecast, clock: Clock) {
        self.forecast = forecast
        self.clock = clock
    }

    public func viewCreated(view: FrontView) {
        self.view = view

        self.view?.setSettingsButton(title: "Settings")
        self.view?.setSolarButton(title: "Daylight")
        self.view?.setDetailsButton(title: "Details")
        self.view?.setLocationButton(title: "Location")

        updateCurrentWeather()
        updateMinMaxValues()
    }

    func updateMinMaxValues() {
        let minData = setMinMax(type: .minimum, temperature: forecast.today?.temperatureMin, time: forecast.today?.temperatureMinTime)
        let maxData = setMinMax(type: .maximum, temperature: forecast.today?.temperatureMax, time: forecast.today?.temperatureMaxTime)

        if let maxTime = forecast.today?.temperatureMaxTime, let minTime = forecast.today?.temperatureMinTime {

            // Put the earlier min/max time on the left.
            let minimumFirst = maxTime.isAfter(minTime)
            let earlyData = minimumFirst ? minData : maxData
            let laterData = minimumFirst ? maxData : minData

            view?.updateEarlyMinMax(earlyData.valueText, at: earlyData.timeText, highlight: earlyData.highlight)
            view?.updateLateMinMax(laterData.valueText, at: laterData.timeText, highlight: laterData.highlight)

        }
    }

    func updateCurrentWeather() {
        var temperatureText = ""
        if let temperature = forecast.current?.temperature {
            temperatureText  = "\(Int(round(temperature.value)))\(temperature.unit.symbol)"
        }
        let weatherText = forecast.current?.summary?.uppercased() ?? ""

        view?.updateCurrentWeather(temperature: temperatureText, weather: weatherText)
    }

    /// Returns displayable data for the today's minimum or maximum temperature.
    ///
    /// - Parameters:
    ///   - type: Flag to indicate today's minimum or maximum.
    ///   - temperature: A temperature measurement.
    ///   - time: The time at which the temperature is expected.
    /// - Returns: Displayable temperature/time data.
    ///
    private func setMinMax(type: MinMaxType,
                           temperature: Measurement<UnitTemperature>?,
                           time: Date?) -> (valueText: String, timeText: String, highlight: Bool) {
        guard let temperature = temperature else {
            return (valueText: "", timeText: "", highlight: false)
        }

        var valueText = ""
        var timeText = ""
        var highlight = false

        valueText = "\(type.rawValue) \(Int(temperature.value))\(temperature.unit.symbol)"
        if let time = time {
            timeText = time.asHHMM(timezone: forecast.timeZone)
            // Set highlight on for future dates.
            highlight = time.isAfter(clock.currentDateTime)
        } else {
            timeText = ""
            highlight = false
        }

        return (valueText: valueText, timeText: timeText, highlight: highlight)
    }
}
