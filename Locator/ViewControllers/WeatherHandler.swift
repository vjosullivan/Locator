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

enum DisplayOption1 {
    case wind  // Display the wind speed and direction.
    case light // Display the UV index and cloud cover.
}

class WeatherHandler: NSObject, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Local constants and variables.

    private let hourLineCount = 37 // The number of lines of hour by hour weather displayed.
    private let dayLineCount  =  8 // The number of lines of day by day weather displayed.

    private var forecast: DarkSkyForecast?
    private var detailType = DetailType.day
    private var displayOption1 = DisplayOption1.wind
    private var cellIdentifier = ""
    private var backgroundColor =  UIColor.black

    func update(forecast: DarkSkyForecast, detailType: DetailType, backgroundColor: UIColor,
                displayOption1: DisplayOption1) {
        self.forecast = forecast
        self.detailType = detailType
        self.displayOption1 = displayOption1
        cellIdentifier = detailType == DetailType.day ? "HourOfDayCell" : "DayOfWeekCell"
        self.backgroundColor = backgroundColor
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // The number of rows displayed is dependent upon whether hourly or daily
        // data is to be displayed and limited by the data available.
        if let forecast = forecast {
            let rowCount = (detailType == .day) ? hourLineCount : dayLineCount
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
        return populate(cell: cell, from: dataPoint, in: timeZone) {
            cell.time.text = dataPoint?.time.asHpm(showMidday: true, timeZone: timeZone)
            cell.time.textColor = (cell.time.text!.substring(to: 1) == "N") ? UIColor.amber : UIColor.white
            cell.maxTemperature.text
                = "\(Int(dataPoint?.temperature?.value ?? 0))\(dataPoint?.temperature?.unit.symbol ?? "")"
        }
    }

    private func populateDayOfWeek(cell: WeatherTableViewCell,
                                   from dataPoint: DataPoint?, in timeZone: String) -> WeatherTableViewCell {
        return populate(cell: cell, from: dataPoint, in: timeZone) {
            cell.time.text = dataPoint?.time.asDDD(timeZone: forecast?.timeZone)
            cell.time.textColor = (cell.time.text!.substring(to: 1) == "S") ? UIColor.amber : UIColor.white
            cell.maxTemperature.text
                = "\(Int(dataPoint?.temperatureMax?.value ?? 0))/\(Int(dataPoint?.temperatureMin?.value ?? 0))\(dataPoint?.temperatureMax?.unit.symbol ?? "")"
        }
    }

    private func populate(cell: WeatherTableViewCell,
                          from dataPoint: DataPoint?, in timeZone: String, completion: () -> Void) -> WeatherTableViewCell {
        if let dataPoint = dataPoint {
            completion()
            cell.icon.text = Weather.representedBy(darkSkyIcon: dataPoint.icon ?? "").symbol
            cell.icon.textColor = Weather.representedBy(darkSkyIcon: dataPoint.icon ?? "").color
            if let precipProbability = dataPoint.precipProbability {
                let precipPercentage = Int((precipProbability + 0.1) * 5.0) * 20
                if precipPercentage > 0 {
                    cell.rain.text = "\(precipPercentage)%"
                    cell.rain.textColor = UIColor.black
                    cell.rain.precipitationType = (dataPoint.precipType == "snow")
                        ? PrecipitationType.snow : PrecipitationType.rain
                    let precipitationColor = (dataPoint.precipType == "snow") ? UIColor.white : UIColor.clearBlue
                    cell.rain.backgroundColor = precipitationColor.withAlphaComponent(CGFloat(0.5 + precipProbability * 0.5))
                    cell.rain.layer.cornerRadius = cell.rain.bounds.width / 2.0
                } else {
                    cell.rain.text = "Dry"
                    cell.rain.textColor = UIColor.white
                    cell.rain.backgroundColor = UIColor.clear
                }
            } else {
                cell.rain.text = "-"
            }
            switch displayOption1 {
            case .wind:
                cell.cloudCover.isHidden = true
                cell.windBearing.isHidden = false
                updateWindbearing(label: cell.windBearing, from: dataPoint.windBearing)
                updateWindspeed(label: cell.windSpeed, from: dataPoint.windSpeed)
            case .light:
                cell.cloudCover.isHidden = false
                cell.windBearing.isHidden = true
                updateCloudCover(image: cell.cloudCover, from: dataPoint.cloudCover)
                updateUVIndex(label: cell.windSpeed, from: dataPoint.uvIndex)
            }
        } else {
            cell.time.text = "???"
        }
        cell.backgroundColor = backgroundColor
        return cell
    }

    private func updateWindbearing(label: UILabel, from measurement: Measurement<UnitAngle>?) {
        guard let measurement = measurement else {
            label.text = ""
            return
        }
        label.text = Weather.windDirection.symbol
        let angle = CGFloat(measurement.value + 90.0) * CGFloat.pi / 180.0
        label.transform = CGAffineTransform.init(rotationAngle: angle)
    }

    private func updateWindspeed(label: UILabel, from measurement: Measurement<UnitSpeed>?) {
        label.backgroundColor = .clear
        label.textColor = .white
        guard let measurement = measurement else {
            label.text = ""
            return
        }
        label.text = "\(Int(measurement.value))\n\(measurement.unit.symbol)"
    }

    private func updateCloudCover(image: UIImageView, from measurement: Double?) {
        guard let measurement = measurement else {
            image.image = nil
            return
        }
        switch measurement {
        case 0.000..<0.025:
            image.image = UIImage(named: "Picon00")
        case 0.025..<0.075:
            image.image = UIImage(named: "Picon05")
        case 0.075..<0.125:
            image.image = UIImage(named: "Picon10")
        case 0.125..<0.175:
            image.image = UIImage(named: "Picon15")
        case 0.175..<0.225:
            image.image = UIImage(named: "Picon20")
        case 0.225..<0.275:
            image.image = UIImage(named: "Picon25")
        case 0.275..<0.325:
            image.image = UIImage(named: "Picon30")
        case 0.325..<0.375:
            image.image = UIImage(named: "Picon35")
        case 0.375..<0.425:
            image.image = UIImage(named: "Picon40")
        case 0.425..<0.475:
            image.image = UIImage(named: "Picon45")
        case 0.475..<0.525:
            image.image = UIImage(named: "Picon50")
        case 0.525..<0.575:
            image.image = UIImage(named: "Picon55")
        case 0.575..<0.625:
            image.image = UIImage(named: "Picon60")
        case 0.625..<0.675:
            image.image = UIImage(named: "Picon65")
        case 0.675..<0.725:
            image.image = UIImage(named: "Picon70")
        case 0.725..<0.775:
            image.image = UIImage(named: "Picon75")
        case 0.775..<0.825:
            image.image = UIImage(named: "Picon80")
        case 0.825..<0.875:
            image.image = UIImage(named: "Picon85")
        case 0.875..<0.925:
            image.image = UIImage(named: "Picon90")
        case 0.925..<0.975:
            image.image = UIImage(named: "Picon95")
        case 0.975...1.000:
            image.image = UIImage(named: "Picon100")
        default:
            image.image = UIImage(named: "PiconXX")
        }
    }

    private func updateUVIndex(label: UILabel, from measurement: Double?) {
        guard let measurement = measurement else {
            label.backgroundColor = .clear
            label.text = ""
            return
        }
        let color = uvColor(measurement)
        label.backgroundColor = color.background
        label.textColor = color.foreground
        label.text = "\(Int(measurement))"
        label.cornerRadius = 8
    }

    private func uvColor(_ value: Double) -> (background:UIColor, foreground: UIColor) {
        let uvColor: (UIColor, UIColor)
        switch value {
        case 0:
            uvColor = (.darkGray, .white)
        case 0..<3:
            uvColor = (.green, .black)
        case 3..<6:
            uvColor = (.yellow, .black)
        case 6..<8:
            uvColor = (.orange, .white)
        case 8..<11:
            uvColor = (.red, .white)
        case 11..<20:
            uvColor = (.purple, .white)
        default:
            uvColor = (.black, .white)
        }
        return uvColor
    }
}
