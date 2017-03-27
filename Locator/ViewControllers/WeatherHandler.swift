//
//  WeatherHandler.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 26/03/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class WeatherHandler: NSObject, UITableViewDataSource, UITableViewDelegate {

    fileprivate var forecast: DarkSkyForecast?

    func update(forecast: DarkSkyForecast) {
        self.forecast = forecast
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let forecast = forecast {
            return Swift.min(25, forecast.hourly?.dataPoints?.count ?? 0)
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! WeatherTableViewCell
        // swiftlint:enable force_cast
        if let dataPoint = forecast?.hourly?.dataPoints?[indexPath.row] {
            cell.time.text = dataPoint.time.asHpm(showMidday: true, timeZone: forecast?.timeZone)
            cell.icon.text = Weather.representedBy(darkSkyIcon: dataPoint.icon ?? "").symbol
            cell.icon.textColor = dataPoint.icon == "clear-day"
                ? .yellow
                : Weather.representedBy(darkSkyIcon: dataPoint.icon ?? "").color
            cell.maxTemperature.text = "\(Int(dataPoint.temperature?.value ?? 0))\(dataPoint.temperature?.unit.symbol ?? "")"
            if let precipProbability = dataPoint.precipProbability {
                let precipPercentage = Int(precipProbability * 10.0) * 10
                if precipPercentage > 0 {
                    cell.rain.text = "\(precipPercentage)%"
                    cell.rain.textColor = UIColor.black
                    cell.rain.backgroundColor = UIColor.skyBlue.lighter().withAlphaComponent(CGFloat(0.5 + precipProbability * 0.5))
                    cell.rain.layer.cornerRadius = cell.rain.bounds.width / 2.0
                } else {
                    cell.rain.text = "·"
                    cell.rain.textColor = UIColor.white
                    cell.rain.backgroundColor = UIColor.black
                }
            } else {
                cell.rain.text = "-"
            }
            cell.summary.text = dataPoint.summary
        } else {
            cell.time.text = "???"
            cell.summary.text = "-"
        }
        return cell
    }
}
