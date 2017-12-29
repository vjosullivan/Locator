//
//  File.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 22/04/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import Foundation

class FrontViewPresenter {

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
    }

    func updateCurrentWeather() {
        var temperatureText = ""
        if let temperature = forecast.current?.temperature {
            temperatureText  = "\(Int(round(temperature.value)))\(temperature.unit.symbol)"
        }
        let weatherText = forecast.current?.summary?.uppercased() ?? ""

        view?.updateCurrentWeather(temperature: temperatureText, weather: weatherText)
    }
}
