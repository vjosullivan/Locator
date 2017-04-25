//
//  FrontView.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 25/04/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

protocol FrontView {
    func initialiseSettingsButton(title: String)
    func initialiseSolarButton(title: String)
    func initialiseDetailsButton(title: String)
    func initialiseLocationButton(title: String)

    func updateEarlyMinMax(_ temperature: String, at time: String, highlight: Bool)
    func updateLateMinMax(_ temperature: String, at time: String, highlight: Bool)
    func updateCurrentWeather(temperature: String, weather: String)
}
