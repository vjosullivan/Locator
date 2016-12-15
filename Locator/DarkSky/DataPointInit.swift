//
//  CurrentConditionsInit.swift
//  Raincoat
//
//  Created by Vincent O'Sullivan on 24/09/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation

extension DataPoint {
    
    init?(dictionary: [String: AnyObject], forecastUnits: DarkSkyUnits) {
     
        guard let timeValue = dictionary["time"] as? Double else {
            return nil
        }
        time = Date(timeIntervalSince1970: timeValue)

        if let t = dictionary["apparentTemperatureMax"] as? Double {
            let temp = round(t * 10) / 10
            apparentTemperature = OptionalMeasurement(value: temp as AnyObject?,    unit: forecastUnits.temperature)
        } else {
            apparentTemperature = nil
        }
        if let t = dictionary["apparentTemperatureMax"] as? Double {
            let temp = round(t * 10) / 10
            apparentTemperatureMax = OptionalMeasurement(value: temp as AnyObject?, unit: forecastUnits.temperature)
        } else {
            apparentTemperatureMax = nil
        }
        if let t = dictionary["apparentTemperatureMin"] as? Double {
            let temp = round(t * 10) / 10
            apparentTemperatureMin = OptionalMeasurement(value: temp as AnyObject?, unit: forecastUnits.temperature)
        } else {
            apparentTemperatureMin = nil
        }
        apparentTemperatureMaxTime = Date(unixDate: dictionary["apparentTemperatureMaxTime"])
        apparentTemperatureMinTime = Date(unixDate: dictionary["apparentTemperatureMinTime"])

        cloudCover = dictionary["cloudCover"]?.doubleValue
        dewPoint   = OptionalMeasurement(value: dictionary["dewPoint"], unit: forecastUnits.temperature)
        humidity   = dictionary["humidity"]?.doubleValue
        icon       = dictionary["icon"] as? String
        moonPhase  = dictionary["moonPhase"]?.doubleValue
        
        nearestStormBearing  = OptionalMeasurement(value: dictionary["nearestStormBearing"],  unit: forecastUnits.angle)
        nearestStormDistance = OptionalMeasurement(value: dictionary["nearestStormDistance"], unit: forecastUnits.distance)

        ozone = dictionary["ozone"]?.doubleValue 
        
        precipAccumulation = OptionalMeasurement(value: dictionary["precipAccumulation"], unit: forecastUnits.accumulation)
        precipIntensity    = OptionalMeasurement(value: dictionary["precipIntensity"],    unit: forecastUnits.rainIntensity)
        precipIntensityMax = OptionalMeasurement(value: dictionary["precipIntensityMax"], unit: forecastUnits.rainIntensity)
        precipIntensityMaxTime = Date(unixDate: dictionary["precipIntensityMaxTime"])
        precipProbability = dictionary["precipProbability"]?.doubleValue
        precipType = dictionary["precipType"] as? String

        pressure = OptionalMeasurement(value: dictionary["pressure"], unit: forecastUnits.airPressure)

        summary = dictionary["summary"] as? String
        
        sunriseTime = Date(unixDate: dictionary["sunriseTime"])
        sunsetTime  = Date(unixDate: dictionary["sunsetTime"])

        if let t = dictionary["temperatureMax"] as? Double {
            let temp = round(t * 10) / 10
            temperature = OptionalMeasurement(value: temp as AnyObject?,    unit: forecastUnits.temperature)
        } else {
            temperature = nil
        }
        if let t = dictionary["temperatureMax"] as? Double {
            let temp = round(t * 10) / 10
            temperatureMax = OptionalMeasurement(value: temp as AnyObject?, unit: forecastUnits.temperature)
        } else {
            temperatureMax = nil
        }
        if let t = dictionary["temperatureMin"] as? Double {
            let temp = round(t * 10) / 10
            temperatureMin = OptionalMeasurement(value: temp as AnyObject?, unit: forecastUnits.temperature)
        } else {
            temperatureMin = nil
        }
        temperatureMaxTime = Date(unixDate: dictionary["temperatureMaxTime"])
        temperatureMinTime = Date(unixDate: dictionary["temperatureMinTime"])

        visibility  = OptionalMeasurement(value: dictionary["visibility"],  unit: forecastUnits.distance)
        windBearing = OptionalMeasurement(value: dictionary["windBearing"], unit: forecastUnits.angle)
        windSpeed   = OptionalMeasurement(value: dictionary["windSpeed"],   unit: forecastUnits.windSpeed)
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
