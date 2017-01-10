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
        
        print("Updating details dispalay")
        if let pressure = forecast.current?.pressure {
            pressureSymbol.text = "\u{F079}"
            pressureLabel.text = "Pressure"
            pressureText.text  = pressure.description
        } else {
            pressureSymbol.text = ""
            pressureLabel.text = "No pressure"
            pressureText.text  = ""
        }
        if let humidity = forecast.current?.humidity {
            humiditySymbol.text = "\u{F07A}"
            humidityLabel.text  = "Humidity"
            humidityText.text   = "\(Int(humidity * 100))%"
        } else {
            humiditySymbol.text = ""
            humidityLabel.text  = ""
            humidityText.text   = ""
        }
        
        if let windSpeed = forecast.current?.windSpeed {
            windLabel.text = "Wind"
            windText.text  = windSpeed.description
        } else {
            windLabel.text = ""
            windText.text  = ""
        }
        if let windDirection = forecast.current?.windBearing {
            print("Wind direction: \(windDirection)")
            windSymbol.text = "\u{F0B1}"
            let angle = CGFloat((windDirection.value + 180.0) * M_PI / 180.0)
            windSymbol.transform = CGAffineTransform.init(rotationAngle: angle)
            windSubtext.text = "from \(cardinal(from: windDirection.value))"
        } else {
            windSymbol.text  = ""
            windSubtext.text = ""
        }
        
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
