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

    @IBOutlet weak var unitsSettings: UISegmentedControl!
    @IBOutlet weak var settingsLabel: UILabel!

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
    }

    func update(forecast: DarkSkyForecast, backgroundColor: UIColor, cornerRadius: CGFloat) {
        let foregroundColor = backgroundColor.darker

        AppSettings.store(key: "units", value: forecast.unitsCode)

        returnButton.setTitleColor(foregroundColor, for: .normal)
        let textColor = backgroundColor.darker
        unitsLabel.textColor = textColor
        unitsSettings.tintColor = textColor
        settingsLabel.textColor = textColor
        view.backgroundColor = backgroundColor
        view.topCornerRadius = cornerRadius
    }

    @IBAction func setUnits(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            AppSettings.store(key: "units", value: "si")
            settingsLabel.text = "Celsius  ·  metres  ·  m/s  ·  hPa"
        case 1:
            AppSettings.store(key: "units", value: "ca")
            settingsLabel.text = "Celsius  ·  kilometers  ·  km/h  ·  kPa"
        case 2:
            AppSettings.store(key: "units", value: "uk2")
            settingsLabel.text = "Celsius  ·  miles  ·  mph  ·  mbar"
        default:
            AppSettings.store(key: "units", value: "us")
            settingsLabel.text = "Fahrenheit  ·  miles  ·  mph  ·  inHg"
        }
    }
}
