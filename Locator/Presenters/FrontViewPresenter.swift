//
//  File.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 22/04/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import Foundation

class FrontViewPresenter {

    private let current: DataPointCodableViewModel
    private var view: FrontView?

    init(currentWeather current: DataPointCodableViewModel) {
        self.current = current
    }

    public func viewCreated(view: FrontView) {
        view.setSettingsButton(title: "Settings")
        view.setSolarButton(title: "Daylight")
        view.setDetailsButton(title: "Details")
        view.setLocationButton(title: "Location")
        view.updateWeatherText(temperature: current.temperature, weather: current.summary.uppercased())
        self.view = view
    }
}
