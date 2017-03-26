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
            print("Rows", forecast.hourly?.dataPoints?.count ?? 0)
            return Swift.min(25, forecast.hourly?.dataPoints?.count ?? 0)
        } else {
            print("No rows.")
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! WeatherTableViewCell
        // swiftlint:enable force_cast
        print("A")
        if let dataPoint = forecast?.hourly?.dataPoints?[indexPath.row] {
            print("B1")
            let time = dataPoint.time
            print("B2")
            let weekday = Calendar.current.component(.weekday, from: time)
            print("B3 \(weekday)")
            cell.time.text = time.asHpm() // DateFormatter().shortWeekdaySymbols[weekday % 7]
            print("B4 \(String(describing: dataPoint.icon))")
            cell.icon.text = Weather.representedBy(darkSkyIcon: dataPoint.icon ?? "").symbol
            cell.icon.textColor = dataPoint.icon == "clear-day" ? .yellow : .white
            print("B4")
            cell.summary.text = dataPoint.summary
            print("C")
        } else {
            print("D")
            cell.time.text = "???"
            cell.summary.text = "-"
        }
        print("E")
        return cell
    }
}
