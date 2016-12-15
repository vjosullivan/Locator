//
//  CurrentConditions.swift
//  Raincoat
//
//  Created by Vincent O'Sullivan on 24/09/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation

struct DataPoint {

    /// The UNIX time at which this data point begins.  Required.
    let time: Date

    /// The apparent or "feels like" temperature.  Not given on daily data point.  Optional.
    let apparentTemperature: Measurement<UnitTemperature>?
    /// The maximum apparent or "feels like" temperature of the day.  Only given on daily data point.  Optional.
    let apparentTemperatureMax: Measurement<UnitTemperature>?
    /// The UNIX time of when apparentTemperatureMax occurs during a given day.
    let apparentTemperatureMaxTime: Date?
    /// The minimum apparent or "feels like" temperature of the day.  Only given on daily data point.  Optional.
    let apparentTemperatureMin: Measurement<UnitTemperature>?
    /// The UNIX time of when apparentTemperatureMin occurs during a given day.  Optional.
    let apparentTemperatureMinTime: Date?

    /// The percentage (sic.) of sky occluded by clouds, between 0 and 1, inclusive.  Optional.
    let cloudCover: Double?
    /// The air temperature at which dew will occur.  Optional.
    let dewPoint: Measurement<UnitTemperature>?
    /// The relative humidity, between 0 and 1, inclusive.  Optional.
    let humidity: Double?

    /// A text summary of this data point, suitable for selecting an icon for display.  Optional.
    /// Known possible values: clear-day, clear-night, rain, snow, sleet, wind, fog, cloudy, partly-cloudy-day
    /// or partly-cloudy-night. (Also hail, thunderstorm or tornado)
    let icon: String?

    /// The fractional part of the lunation number during the given day.  Only on daily data point.  Optional.
    /// - 0.0 ⋅ new mooon,
    /// - 0.25 ⋅ first quarter moon,
    /// - 0.5 ⋅ full moon,
    /// - 0.75 ⋅ last quarter moon.
    ///
    /// (The ranges in between these represent waxing crescent, waxing gibbous, waning gibbous, and waning crescent moons, respectively.)
    let moonPhase: Double?
    
    /// The approximate direction of the nearest storm in degrees, with true north at 0° and progressing clockwise.
    /// Only on current data point.  Optional.
    ///
    /// (If nearestStormDistance is zero, then this value will not be defined.)
    let nearestStormBearing: Measurement<UnitAngle>?
    /// The approximate distance to the nearest storm.
    ///
    /// (A storm distance of 0 doesn’t necessarily refer to a storm at the requested location, 
    ///  but rather a storm in the vicinity of that location.)
    let nearestStormDistance: Measurement<UnitLength>?

    /// The columnar density of total atmospheric ozone at the given time in Dobson units.  Optional.
    let ozone: Double?

    /// The amount of snowfall accumulation expected to occur.  Not defined if no snowfall expected.  Hourly and daily only.
    let precipAccumulation: Measurement<UnitLength>?
    /// The intensity (mm or inches of liquid water per hour) of precipitation occurring at the given time.  Optional.
    ///
    /// This value is conditional on probability (that is, assuming any precipitation occurs at all)
    /// for minutely data points, and unconditional otherwise.
    let precipIntensity: Measurement<UnitSpeed>?
    /// The maximum value of precipIntensity during a given day.  Optional.
    let precipIntensityMax: Measurement<UnitSpeed>?
    /// The UNIX time of when precipIntensityMax occurs during a given day.  Optional.
    let precipIntensityMaxTime: Date?
    /// The probability of precipitation occurring, between 0 and 1, inclusive.
    let precipProbability: Double?
    /// The type of precipitation occurring at the given time.  Values "rain", "snow", or "sleet".  Optional.
    let precipType: String?
    /// The sea-level air pressure.  Optional.
    let pressure: Measurement<UnitPressure>?
    /// Text summary of this data point.
    let summary: String?
    /// The UNIX time of when the sun will rise during a given day.  Only on daily.  Optional.
    let sunriseTime: Date?
    /// The UNIX time of when the sun will set during a given day.  Only on daily.  Optional.
    let sunsetTime: Date?

    /// The air temperature.  Optional.
    let temperature: Measurement<UnitTemperature>?
    /// The maximum value of temperature during a given day.  Only on daily.  Optional.
    let temperatureMax: Measurement<UnitTemperature>?
    /// The UNIX time of when temperatureMax occurs during a given day.  Only on daily.  Optional.
    let temperatureMaxTime: Date?
    /// The minimum value of temperature during a given day.  Only on daily.  Optional.
    let temperatureMin: Measurement<UnitTemperature>?
    /// The UNIX time of when temperatureMin occurs during a given day.  Only on daily.  Optional.
    let temperatureMinTime: Date?

    /// The average visibility (capped at approx. 10 miles).
    let visibility: Measurement<UnitLength>?

    /// The direction that the wind is coming from in degrees, clockwise from true north. Optional.
    ///
    /// (If windSpeed is zero, then this value will not be defined.)
    let windBearing: Measurement<UnitAngle>?
    /// The wind speed.
    let windSpeed: Measurement<UnitSpeed>?
}
