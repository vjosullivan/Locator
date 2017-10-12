//
//  SettingsViewController.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 02/01/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var unitsLabel: UILabel!
    @IBOutlet weak var options1Label: UILabel!

    @IBOutlet weak var unitsSettings: UISegmentedControl!
    @IBOutlet weak var option1Settings: UISegmentedControl!
    @IBOutlet weak var displayedUnits: UILabel!
    @IBOutlet weak var displayedSettings: UILabel!

    @IBOutlet weak var returnButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        let units = DarkSkyUnits.units(from: AppSettings.retrieve(key: "units", defaultValue: "auto"))
        switch units {
        case DarkSkyUnits.us:
            unitsSettings.selectedSegmentIndex = 3
        case DarkSkyUnits.uk2:
            unitsSettings.selectedSegmentIndex = 2
        case DarkSkyUnits.ca:
            unitsSettings.selectedSegmentIndex = 1
        default:
            unitsSettings.selectedSegmentIndex = 0
        }
        setUnits(unitsSettings)
        let option1 = AppSettings.retrieve(key: "option1", defaultValue: "wind")
        switch option1 {
        case "uvIndex":
            option1Settings.selectedSegmentIndex = 1
        default:
            option1Settings.selectedSegmentIndex = 0
        }
        setOption1(option1Settings)
    }

    func update(forecast: DarkSkyForecast, backgroundColor: UIColor, cornerRadius: CGFloat) {
        let foregroundColor = backgroundColor.darker

        AppSettings.store(key: "units", value: forecast.unitsCode)

        returnButton.setTitleColor(foregroundColor, for: .normal)
        let textColor = backgroundColor.darker
        unitsLabel.textColor = textColor
        unitsSettings.tintColor = textColor
        displayedUnits.textColor = textColor
        displayedSettings.textColor = textColor
        options1Label.textColor = textColor
        option1Settings.tintColor = textColor
        view.backgroundColor = backgroundColor
        view.topCornerRadius = cornerRadius
    }

    @IBAction func setUnits(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            AppSettings.store(key: "units", value: "si")
            displayedUnits.text = "Celsius  ·  metres  ·  m/s  ·  hPa"
        case 1:
            AppSettings.store(key: "units", value: "ca")
            displayedUnits.text = "Celsius  ·  kilometers  ·  km/h  ·  kPa"
        case 2:
            AppSettings.store(key: "units", value: "uk2")
            displayedUnits.text = "Celsius  ·  miles  ·  mph  ·  mbar"
        default:
            AppSettings.store(key: "units", value: "us")
            displayedUnits.text = "Fahrenheit  ·  miles  ·  mph  ·  inHg"
        }
    }

    @IBAction func setOption1(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            AppSettings.store(key: "option1", value: "uvIndex")
            displayedSettings.text = "cloud cover  ·  UV index"
        default:
            AppSettings.store(key: "option1", value: "wind")
            displayedSettings.text = "wind bearing  ·  wind speed"
       }
    }
}
