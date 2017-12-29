//
//  DetailsViewController.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 29/12/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    private enum MinMaxType: String {
        case minimum = "Low"
        case maximum = "High"
    }

    @IBOutlet weak var minTempValue: UILabel!
    @IBOutlet weak var minTempTime: UILabel!
    @IBOutlet weak var maxTempValue: UILabel!
    @IBOutlet weak var maxTempTime: UILabel!

    @IBOutlet weak var pressureSymbol: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var pressureText: UILabel!

    @IBOutlet weak var windSymbol: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var windText: UILabel!
    @IBOutlet weak var windSubtext: UILabel!

    @IBOutlet weak var humiditySymbol: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var humidityText: UILabel!

    @IBOutlet weak var returnButton: UIButton!

    @IBOutlet weak var detailsLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func update(forecast: DarkSkyForecast, backgroundColor: UIColor, cornerRadius: CGFloat) {
        let foregroundColor = backgroundColor.darker

        if let today = forecast.today {
            updateMinMaxValues(for: today, timeZone: forecast.timeZone)
        }
        if let current = forecast.current {
            updatePressure(from: current.pressure)
            updateHumidity(from: current.humidity)
            updateWindSpeed(from: current.windSpeed)
            updateWindDirection(from: current.windBearing)
        }

        minTempValue.textColor = foregroundColor
        minTempTime.textColor = foregroundColor
        maxTempValue.textColor = foregroundColor
        maxTempTime.textColor = foregroundColor

        pressureSymbol.textColor = foregroundColor
        pressureLabel.textColor = foregroundColor
        pressureText.textColor = foregroundColor

        windSymbol.textColor = foregroundColor
        windLabel.textColor = foregroundColor
        windText.textColor = foregroundColor
        windSubtext.textColor = foregroundColor

        humiditySymbol.textColor = foregroundColor
        humidityLabel.textColor = foregroundColor
        humidityText.textColor = foregroundColor
        detailsLabel.textColor = foregroundColor

        detailsLabel.text = forecast.hourly?.summary ?? ""

        returnButton.setTitleColor(foregroundColor, for: .normal)
        view.backgroundColor = backgroundColor
        view.topCornerRadius = cornerRadius
    }

    func updateMinMaxValues(for today: DataPoint, timeZone: String) {
        let minData = setMinMax(type: .minimum, temperature: today.temperatureMin, time: today.temperatureMinTime, timeZone: timeZone)
        let maxData = setMinMax(type: .maximum, temperature: today.temperatureMax, time: today.temperatureMaxTime, timeZone: timeZone)

        if let maxTime = today.temperatureMaxTime, let minTime = today.temperatureMinTime {

            // Put the earlier min/max time on the left.
            let minimumFirst = maxTime.isAfter(minTime)
            let earlyData = minimumFirst ? minData : maxData
            let laterData = minimumFirst ? maxData : minData

            updateEarlyMinMax(earlyData.valueText, at: earlyData.timeText, highlight: earlyData.highlight)
            updateLateMinMax(laterData.valueText, at: laterData.timeText, highlight: laterData.highlight)
        }
    }

    /// Returns displayable data for the today's minimum or maximum temperature.
    ///
    /// - Parameters:
    ///   - type: Flag to indicate today's minimum or maximum.
    ///   - temperature: A temperature measurement.
    ///   - time: The time at which the temperature is expected.
    /// - Returns: Displayable temperature/time data.
    ///
    private func setMinMax(type: MinMaxType,
                           temperature: Measurement<UnitTemperature>?,
                           time: Date?,
                           timeZone: String) -> (valueText: String, timeText: String, highlight: Bool) {
        guard let temperature = temperature else {
            return (valueText: "", timeText: "", highlight: false)
        }

        var valueText = ""
        var timeText = ""
        var highlight = false

        valueText = "\(type.rawValue) \(Int(temperature.value))\(temperature.unit.symbol)"
        if let time = time {
            timeText = time.asHHMM(timezone: timeZone)
            // Set highlight on for future dates.
            highlight = time.isAfter(SystemClock().currentDateTime)
        } else {
            timeText = ""
            highlight = false
        }

        return (valueText: valueText, timeText: timeText, highlight: highlight)
    }

    func updateEarlyMinMax(_ temperature: String, at time: String, highlight: Bool) {
        minTempValue.text = temperature
        if highlight {
            minTempValue.textColor = UIColor.amber
        }
        minTempTime.text = time
        minTempTime.textColor = minTempValue.textColor
    }

    func updateLateMinMax(_ temperature: String, at time: String, highlight: Bool) {
        maxTempValue.text = temperature
        if highlight {
            maxTempValue.textColor = UIColor.amber
        }
        maxTempTime.text = time
        maxTempTime.textColor = maxTempValue.textColor
    }


    /// Updates the air pressure display from the supplied air pressure measurement.
    /// Different air pressure units require slightly different display formats.
    ///
    /// - Parameter measurement: An air pressure measurement.
    ///
    private func updatePressure(from measurement: Measurement<UnitPressure>?) {
        if let measurement = measurement {
            pressureSymbol.text = Weather.barometer.symbol
            pressureLabel.text = "Pressure"
            let pressureValue: String
            switch measurement.unit {
            case UnitPressure.inchesOfMercury:
                pressureValue = String(Double(Int(measurement.value * 100)) / 100.0)
            case UnitPressure.kilopascals:
                pressureValue = String(Double(Int(measurement.value * 10)) / 10.0)
            default:
                pressureValue = String(Int(measurement.value))
            }
            pressureText.text  = "\(pressureValue) \(measurement.unit.symbol)"
        } else {
            pressureSymbol.text = ""
            pressureLabel.text = "No pressure"
            pressureText.text  = ""
        }
    }

    /// Updates the wind speed display from the supplied measurement.
    ///
    /// - Parameter measurement: A wind speed measurement.
    ///
    private func updateWindSpeed(from measurement: Measurement<UnitSpeed>?) {
        if let windSpeed = measurement {
            windLabel.text = "Wind"
            windText.text  = windSpeed.description
        } else {
            windLabel.text = ""
            windText.text  = ""
        }
    }

    /// Updates the wind direction display from the supplied measurement.
    ///
    /// - Parameter measurement: A wind direction measurement.
    ///
    private func updateWindDirection(from measurement: Measurement<UnitAngle>?) {
        if let windDirection = measurement {
            windSymbol.text = Weather.windDirection.symbol
            // Add 90° clockwise because the icon currently used points east (90°) 
            // when the direction value is zero (north).
            let angle = CGFloat(windDirection.value + 90.0) * CGFloat.pi / 180.0
            windSymbol.transform = CGAffineTransform.init(rotationAngle: angle)
            windSubtext.text = "from \(cardinal(from: windDirection.value))"
        } else {
            windSymbol.text  = ""
            windSubtext.text = ""
        }
    }

    /// Helper function: Updates humidity display on screen.
    ///
    /// - Parameter value: Relative humidity value in range 0 to 1.
    ///
    private func updateHumidity(from value: Double?) {
        if let humidity = value {
            humiditySymbol.text = Weather.humidity.symbol
            humidityLabel.text  = "Humidity"
            humidityText.text   = "\(Int(humidity * 100))%"
        } else {
            humiditySymbol.text = ""
            humidityLabel.text  = ""
            humidityText.text   = ""
        }
    }

    private func cardinal(from degrees: Double) -> String {
        switch degrees {
        case 0...22.5:
            return "north"
        case 22.5...67.5:
            return "north-east"
        case 67.5...112.5:
            return "east"
        case 112.5...157.5:
            return "south-east"
        case 157.5...202.5:
            return "south"
        case 202.5...247.5:
            return "south-west"
        case 247.5...292.5:
            return "west"
        case 292.5...337.5:
            return "north-west"
        case 337.5...360.0:
            return "north"
        default:
            return "somewhere"
        }
    }
}
