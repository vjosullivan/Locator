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
    private let dayLineCount  = 15 // The number of lines of day by day weather displayed.

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
            if detailType == .day {
                return Swift.min(hourLineCount, forecast.hourly?.dataPoints?.count ?? 0)
            } else {
                return Swift.min(dayLineCount, forecast.daily?.dataPoints?.count ?? 0)
            }
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
            let highestTemperature = "\(Int(dataPoint?.temperatureHigh?.value ?? 0))"
            let lowestTmperature = "\(Int(dataPoint?.temperatureLow?.value ?? 0))"
            let temperatureSymbol = "\(dataPoint?.temperatureHigh?.unit.symbol ?? "")"
            cell.maxTemperature.text = highestTemperature + "/" + lowestTmperature + temperatureSymbol
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
                cell.cloudCover.image = cloudCoverImage(from: dataPoint.cloudCover)
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

    /// Returns an image that illustrates the amount of cloud cover
    /// between 0.0 (clear) and 1.0 (fully overcast).
    ///
    /// - Parameter measurement: The amount of cloud cover.
    /// - Returns: A cloud cover image.
    ///
    private func cloudCoverImage(from measurement: Double?) -> UIImage? {
        guard let measurement = measurement else {
            return nil
        }
        switch measurement {
        case 0.000..<0.025: return UIImage(named: "Picon00")
        case 0.025..<0.075: return UIImage(named: "Picon05")
        case 0.075..<0.125: return UIImage(named: "Picon10")
        case 0.125..<0.175: return UIImage(named: "Picon15")
        case 0.175..<0.225: return UIImage(named: "Picon20")
        case 0.225..<0.275: return UIImage(named: "Picon25")
        case 0.275..<0.325: return UIImage(named: "Picon30")
        case 0.325..<0.375: return UIImage(named: "Picon35")
        case 0.375..<0.425: return UIImage(named: "Picon40")
        case 0.425..<0.475: return UIImage(named: "Picon45")
        case 0.475..<0.525: return UIImage(named: "Picon50")
        case 0.525..<0.575: return UIImage(named: "Picon55")
        case 0.575..<0.625: return UIImage(named: "Picon60")
        case 0.625..<0.675: return UIImage(named: "Picon65")
        case 0.675..<0.725: return UIImage(named: "Picon70")
        case 0.725..<0.775: return UIImage(named: "Picon75")
        case 0.775..<0.825: return UIImage(named: "Picon80")
        case 0.825..<0.875: return UIImage(named: "Picon85")
        case 0.875..<0.925: return UIImage(named: "Picon90")
        case 0.925..<0.975: return UIImage(named: "Picon95")
        case 0.975...1.000: return UIImage(named: "Picon100")
        default:            return UIImage(named: "PiconXX")
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
