//
//  CurrentConditionsInit.swift
//  Raincoat
//
//  Created by Vincent O'Sullivan on 24/09/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation

extension DataPoint {

    init?(dictionary: [String: AnyObject], units: DarkSkyUnits) {

        guard let timeValue = dictionary["time"] as? Double else {
            return nil
        }
        time = Date(timeIntervalSince1970: timeValue)

        apparentTemperature = getTemperature(from: dictionary["apparentTemperature"], unit: units.temperature)
        apparentTemperatureMax = getTemperature(from: dictionary["apparentTemperatureMax"], unit: units.temperature)
        apparentTemperatureMin = getTemperature(from: dictionary["apparentTemperatureMin"], unit: units.temperature)
        apparentTemperatureMaxTime = Date(unixDate: dictionary["apparentTemperatureMaxTime"])
        apparentTemperatureMinTime = Date(unixDate: dictionary["apparentTemperatureMinTime"])

        cloudCover = dictionary["cloudCover"]?.doubleValue
        dewPoint   = OptionalMeasurement(value: dictionary["dewPoint"], unit: units.temperature)
        humidity   = dictionary["humidity"]?.doubleValue
        icon       = dictionary["icon"] as? String
        moonPhase  = dictionary["moonPhase"]?.doubleValue

        nearestStormBearing  = OptionalMeasurement(value: dictionary["nearestStormBearing"], unit: units.angle)
        nearestStormDistance = OptionalMeasurement(value: dictionary["nearestStormDistance"], unit: units.distance)

        ozone = dictionary["ozone"]?.doubleValue

        precipAccumulation = OptionalMeasurement(value: dictionary["precipAccumulation"], unit: units.accumulation)
        precipIntensity    = OptionalMeasurement(value: dictionary["precipIntensity"], unit: units.rainIntensity)
        precipIntensityMax = OptionalMeasurement(value: dictionary["precipIntensityMax"], unit: units.rainIntensity)
        precipIntensityMaxTime = Date(unixDate: dictionary["precipIntensityMaxTime"])
        precipProbability = dictionary["precipProbability"]?.doubleValue
        precipType = dictionary["precipType"] as? String

        if let p = dictionary["pressure"] as? Double {
            pressure = OptionalMeasurement(value: round(p) as AnyObject?, unit: UnitPressure.hectopascals)?
                .converted(to: units.airPressure)
        } else {
            pressure = nil
        }
        summary = dictionary["summary"] as? String
        sunriseTime = Date(unixDate: dictionary["sunriseTime"])
        sunsetTime  = Date(unixDate: dictionary["sunsetTime"])

        temperature = getTemperature(from: dictionary["temperature"], unit: units.temperature)
        temperatureMax = getTemperature(from: dictionary["temperatureMax"], unit: units.temperature)
        temperatureMin = getTemperature(from: dictionary["temperatureMin"], unit: units.temperature)
        temperatureMaxTime = Date(unixDate: dictionary["temperatureMaxTime"])
        temperatureMinTime = Date(unixDate: dictionary["temperatureMinTime"])

        visibility  = OptionalMeasurement(value: dictionary["visibility"], unit: units.distance)
        windBearing = OptionalMeasurement(value: dictionary["windBearing"], unit: units.angle)
        if let w = dictionary["windSpeed"] as? Double {
            windSpeed   = OptionalMeasurement(value: round(w) as AnyObject?, unit: units.windSpeed)
        } else {
            windSpeed   = nil
        }
    }
}

fileprivate extension Date {

    /// Returns a `Date` provided it can be generated from the supplied data.
    ///
    /// - parameter value: A Unix date value.
    ///
    /// - returns: A `Date` provided it can be generated from the supplied data, otherwise nil.
    ///
    init?(unixDate: AnyObject?) {
        guard let value = unixDate as? TimeInterval else {
            return nil
        }
        self.init(timeIntervalSince1970: value)
    }
}

fileprivate func getTemperature(from: Any?, unit: UnitTemperature) -> Measurement<UnitTemperature>? {
    guard let extractedValue = from as? Double else {
        return nil
    }
    let temp = round(extractedValue * 10) / 10
    return OptionalMeasurement(value: temp as AnyObject?, unit: unit)
}

/// Returns a `Measurement` provided it can be created using the supplied data, otherwise `nil`.
///
/// - Parameters:
///   - value: The numeric value of the measurement.
///   - unit: The measurement units (e.g. mph, °C, etc.).
/// - Returns: A valid `Measurement` or `nil`.
fileprivate func OptionalMeasurement<UnitType: Unit>(value: AnyObject?, unit: UnitType) -> Measurement<UnitType>? {
    if let value = value as? Double {
        return Measurement(value: value, unit: unit)
    }
    return nil
}
