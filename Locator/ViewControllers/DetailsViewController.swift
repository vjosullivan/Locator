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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func update(forecast: DarkSkyForecast, foregroundColor: UIColor?, backgroundColor: UIColor?) {

        let foreColor = foregroundColor ?? UIColor.white
        let backColor = backgroundColor ?? UIColor.darkGray

        updatePressure(from: forecast.current?.pressure)
        updateHumidity(from: forecast.current?.humidity)
        updateWindSpeed(from: forecast.current?.windSpeed)
        updateWindDirection(from: forecast.current?.windBearing)

        pressureSymbol.textColor = foreColor
        pressureLabel.textColor = foreColor
        pressureText.textColor = foreColor

        windSymbol.textColor = foreColor
        windLabel.textColor = foreColor
        windText.textColor = foreColor
        windSubtext.textColor = foreColor

        humiditySymbol.textColor = foreColor
        humidityLabel.textColor = foreColor
        humidityText.textColor = foreColor

        returnButton.setTitleColor(foreColor, for: .normal)
        view.backgroundColor = backColor
    }

    private func updatePressure(from measurement: Measurement<UnitPressure>?) {
        if let measurement = measurement {
            pressureSymbol.text = "\u{F079}"
            pressureLabel.text = "Pressure"
            pressureText.text  = measurement.description
        } else {
            pressureSymbol.text = ""
            pressureLabel.text = "No pressure"
            pressureText.text  = ""
        }
    }

    private func updateWindSpeed(from measurement: Measurement<UnitSpeed>?) {
        if let windSpeed = measurement {
            windLabel.text = "Wind"
            windText.text  = windSpeed.description
        } else {
            windLabel.text = ""
            windText.text  = ""
        }
    }

    private func updateWindDirection(from measurement: Measurement<UnitAngle>?) {
        if let windDirection = measurement {
            windSymbol.text = Weather.windDirection.symbol
            let angle = CGFloat((windDirection.value + 180.0) * M_PI / 180.0)
            windSymbol.transform = CGAffineTransform.init(rotationAngle: angle)
            windSubtext.text = "from \(cardinal(from: windDirection.value))"
        } else {
            windSymbol.text  = ""
            windSubtext.text = ""
        }
    }

    private func updateHumidity(from value: Double?) {
        if let humidity = value {
            humiditySymbol.text = "\u{F07A}"
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
