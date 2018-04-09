//
//  DataPointCodable.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 07/04/2018.
//  Copyright © 2018 Vincent O'Sullivan. All rights reserved.
//

import Foundation

struct DataPointCodable: Codable {
    let time: Date

    let apparentTemperature: Double?
    let apparentTemperatureHigh: Double?
    let apparentTemperatureHighTime: Date?
    let apparentTemperatureLow: Double?
    let apparentTemperatureLowTime: Date?
    let cloudCover: Double?
    let dewPoint: Double?
    let humidity: Double?
    let icon: String?
    let moonPhase: Double?
    let nearestStormBearing: Double?
    let nearestStormDistance: Double?
    let ozone: Double?
    let precipAccumulation: Double?
    let precipIntensity: Double?
    let precipIntensityMax: Double?
    let precipIntensityMaxTime: Date?
    let precipProbability: Double?
    let precipType: String?
    let pressure: Double?
    let summary: String?
    let sunriseTime: Date?
    let sunsetTime: Date?
    let temperature: Double?
    let temperatureHigh: Double?
    let temperatureHighTime: Date?
    let temperatureLow: Double?
    let temperatureLowTime: Date?
    let uvIndex: Int?
    let uvIndexTime: Date?
    let visibility: Double?
    let windBearing: Double?
    let windGust: Double?
    let windSpeed: Double?

    var units: String?
}
