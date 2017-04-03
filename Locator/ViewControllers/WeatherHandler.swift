//
//  WeatherHandler.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 26/03/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import UIKit

enum DetailType {
    case day
    case week
}

class WeatherHandler: NSObject, UITableViewDataSource, UITableViewDelegate {

    fileprivate var forecast: DarkSkyForecast?
    fileprivate var detailType = DetailType.day
    fileprivate var cellIdentifier = ""

    func update(forecast: DarkSkyForecast, detailType: DetailType) {
        self.forecast = forecast
        self.detailType = detailType
        cellIdentifier = detailType == DetailType.day ? "HourOfDayCell" : "DayOfWeekCell"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let forecast = forecast {
            let rowCount = (detailType == .day) ? 25 : 8
            return Swift.min(rowCount, forecast.hourly?.dataPoints?.count ?? 0)
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        let cell = tableView
            .dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! WeatherTableViewCell
        // swiftlint:enable force_cast

        switch detailType {
        case .day:
            return populateHourOfDay(cell: cell,
                                     from: forecast?.hourly?.dataPoints?[indexPath.row], in: forecast?.timeZone ?? "")
        case .week:
            return populateDayOfWeek(cell: cell,
                                     from: forecast?.daily?.dataPoints?[indexPath.row], in: forecast?.timeZone ?? "")
        }
    }

    private func populateHourOfDay(cell: WeatherTableViewCell,
                                   from dataPoint: DataPoint?, in timeZone: String) -> WeatherTableViewCell {
        if let dataPoint = dataPoint {
            cell.time.text = dataPoint.time.asHpm(showMidday: true, timeZone: timeZone)
            cell.icon.text = Weather.representedBy(darkSkyIcon: dataPoint.icon ?? "").symbol
            cell.icon.textColor = dataPoint.icon == "clear-day"
                ? .yellow
                : Weather.representedBy(darkSkyIcon: dataPoint.icon ?? "").color
            cell.maxTemperature.text
                = "\(Int(dataPoint.temperature?.value ?? 0))\(dataPoint.temperature?.unit.symbol ?? "")"
            if let precipProbability = dataPoint.precipProbability {
                let precipPercentage = Int((precipProbability + 0.1) * 5.0) * 20
                if precipPercentage > 0 {
                    cell.rain.text = "\(precipPercentage)%"
                    cell.rain.textColor = UIColor.black
                    cell.rain.precipitationType = (dataPoint.precipType == "snow")
                        ? PrecipitationType.snow : PrecipitationType.rain
                    let backColor = (dataPoint.precipType == "snow") ? UIColor.white : UIColor.skyBlue.lighter()
                    cell.rain.backgroundColor = backColor.withAlphaComponent(CGFloat(0.5 + precipProbability * 0.5))
                    cell.rain.layer.cornerRadius = cell.rain.bounds.width / 2.0
                } else {
                    cell.rain.text = "Dry"
                    cell.rain.textColor = UIColor.white
                    cell.rain.backgroundColor = UIColor.black
                    updateWindbearing(label: cell.windBearing, from: dataPoint.windBearing)
                    updateWindspeed(label: cell.windSpeed, from: dataPoint.windSpeed)
                }
            } else {
                cell.rain.text = "-"
            }
            //cell.summary.text = dataPoint.summary
        } else {
            cell.time.text = "???"
            //cell.summary.text = "-"
        }
        return cell
    }

    private func populateDayOfWeek(cell: WeatherTableViewCell,
                                   from dataPoint: DataPoint?, in timeZone: String) -> WeatherTableViewCell {
        if let dataPoint = dataPoint {
            cell.time.text = dataPoint.time.asDDD(timeZone: forecast?.timeZone)
            cell.icon.text = Weather.representedBy(darkSkyIcon: dataPoint.icon ?? "").symbol
            cell.icon.textColor = dataPoint.icon == "clear-day"
                ? .yellow
                : Weather.representedBy(darkSkyIcon: dataPoint.icon ?? "").color
            cell.maxTemperature.text
                = "\(Int(dataPoint.temperatureMax?.value ?? 0))\(dataPoint.temperatureMax?.unit.symbol ?? "")"
            if let precipProbability = dataPoint.precipProbability {
                let precipPercentage = Int((precipProbability + 0.1) * 5.0) * 20
                if precipPercentage > 0 {
                    cell.rain.text = "\(precipPercentage)%"
                    cell.rain.textColor = UIColor.black
                    cell.rain.precipitationType = (dataPoint.precipType == "snow")
                        ? PrecipitationType.snow : PrecipitationType.rain
                    let backColor = (dataPoint.precipType == "snow") ? UIColor.white : UIColor.skyBlue.lighter()
                    cell.rain.backgroundColor = backColor.withAlphaComponent(CGFloat(0.5 + precipProbability * 0.5))
                    cell.rain.layer.cornerRadius = cell.rain.bounds.width / 2.0
                } else {
                    cell.rain.text = "Dry"
                    cell.rain.textColor = UIColor.white
                    cell.rain.backgroundColor = UIColor.black
                }
                updateWindbearing(label: cell.windBearing, from: dataPoint.windBearing)
                updateWindspeed(label: cell.windSpeed, from: dataPoint.windSpeed)
            } else {
                cell.rain.text = "-"
            }
            //cell.summary.text = dataPoint.summary
        } else {
            cell.time.text = "???"
            //cell.summary.text = "-"
        }
        return cell
    }

    private func updateWindbearing(label: UILabel, from measurement: Measurement<UnitAngle>?) {
        if let windDirection = measurement {
            label.text = Weather.windDirection.symbol
            let angle = CGFloat(windDirection.value + 90.0) * CGFloat.pi / 180.0
            label.transform = CGAffineTransform.init(rotationAngle: angle)
        } else {
            label.text  = ""
        }
    }

    private func updateWindspeed(label: UILabel, from measurement: Measurement<UnitSpeed>?) {
        if let measurement = measurement {
            label.text = "\(Int(measurement.value))\n\(measurement.unit.symbol)"
        } else {
            label.text = ""
        }
    }
}
