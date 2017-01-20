//
//  DarkSkyForecast.swift
//  Raincoat
//
//  Created by Vincent O'Sullivan on 23/09/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation

struct DarkSkyForecast {

    let forecastUnits: DarkSkyUnits

    let latitude: Measurement<UnitAngle>
    let longitude: Measurement<UnitAngle>

    let timeZone: String

    let current: DataPoint?

    let minutely: DetailedForecast?
    let hourly: DetailedForecast?
    let daily: DetailedForecast?

    var today: DataPoint? {
        return daily?.dataPoints?[0]
    }

    let unitsCode: String

    init?(dictionary: [String: AnyObject]) {
        guard let units = dictionary["flags"]?["units"] as? String,
            let latitudeValue = dictionary["latitude"] as? Double,
            let longitudeValue = dictionary["longitude"] as? Double,
            let timeZoneValue = dictionary["timezone"] as? String else {
                return nil
        }
        unitsCode = units
        forecastUnits = DarkSkyUnits.units(from: units)

        latitude  = Measurement(value: latitudeValue, unit: forecastUnits.angle)
        longitude = Measurement(value: longitudeValue, unit: forecastUnits.angle)

        timeZone = timeZoneValue

        if let currentWeather = dictionary["currently"] as? [String: AnyObject] {
            current = DataPoint(dictionary: currentWeather, units: forecastUnits)
        } else {
            current = nil
        }

        minutely = DetailedForecast(dictionary: dictionary["minutely"] as? [String: AnyObject], units: forecastUnits)
        hourly   = DetailedForecast(dictionary: dictionary["hourly"] as? [String: AnyObject], units: forecastUnits)
        daily    = DetailedForecast(dictionary: dictionary["daily"] as? [String: AnyObject], units: forecastUnits)
    }
}
