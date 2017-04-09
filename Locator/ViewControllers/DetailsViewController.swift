//
//  DetailsViewController.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 29/12/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

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

        updatePressure(from: forecast.current?.pressure)
        updateHumidity(from: forecast.current?.humidity)
        updateWindSpeed(from: forecast.current?.windSpeed)
        updateWindDirection(from: forecast.current?.windBearing)

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
