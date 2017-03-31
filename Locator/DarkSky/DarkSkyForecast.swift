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

    let alerts: [Alert]?

    var today: DataPoint? {
        return daily?.dataPoints?[0]
    }

    /// The rain intensity for the next hour.  The figure is factorised to a range
    /// of 0.0 to 1.0 where 1.0 represents 10.0 mm/hr or heavy rain.
    var minutelyRainIntensity: [Double] {
        guard let points = minutely?.dataPoints, points.count == 61 else {
            return [Double]()
        }
        var data = [Double]()
        for point in points {
            data.append(point.precipIntensity?.converted(to: UnitSpeed.millimetersPerHour).value ?? 0.0)
        }
        return RainIntensity(data: data).factorised()
    }

    var minutelyRainProbability: [Double] {
        guard let points = minutely?.dataPoints else {
            return [Double]()
        }
        return points.map { $0.precipProbability ?? 0.0 }
    }

    let unitsCode: String

    init?(dictionary: [String: AnyObject]) {
        guard let units = dictionary["flags"]?["units"] as? String,
            let latitude = dictionary["latitude"] as? Double,
            let longitude = dictionary["longitude"] as? Double,
            let timeZoneValue = dictionary["timezone"] as? String else {
                return nil
        }
        unitsCode = units
        forecastUnits = DarkSkyUnits.units(from: units)

        self.latitude  = Measurement(value: latitude, unit: forecastUnits.angle)
        self.longitude = Measurement(value: longitude, unit: forecastUnits.angle)

        timeZone = timeZoneValue

        if let currentWeather = dictionary["currently"] as? [String: AnyObject] {
            current = DataPoint(dictionary: currentWeather, units: forecastUnits)
        } else {
            current = nil
        }

        minutely = DetailedForecast(dictionary: dictionary["minutely"] as? [String: AnyObject], units: forecastUnits)
        hourly   = DetailedForecast(dictionary: dictionary["hourly"] as? [String: AnyObject], units: forecastUnits)
        daily    = DetailedForecast(dictionary: dictionary["daily"] as? [String: AnyObject], units: forecastUnits)
        alerts   = Alerts(from: dictionary["alerts"] as? [[String: AnyObject]])?.alerts
    }

    private func extractAlerts(dictionary: [String: AnyObject]?) -> [Alert] {
        return []
    }
}
