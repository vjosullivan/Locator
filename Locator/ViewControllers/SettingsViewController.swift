//
//  SettingsViewController.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 02/01/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var usButton: UIButton!
    @IBOutlet weak var ukButton: UIButton!
    @IBOutlet weak var caButton: UIButton!
    @IBOutlet weak var siButton: UIButton!

    @IBOutlet weak var usUnits: UILabel!
    @IBOutlet weak var ukUnits: UILabel!
    @IBOutlet weak var caUnits: UILabel!
    @IBOutlet weak var siUnits: UILabel!

    @IBOutlet weak var settingsLabel: UILabel!

    @IBOutlet weak var returnButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Settings viewDidLoad")
        print("Settings: units are \(AppSettings.retrieve(key: "units", defaultValue: "None!"))")
    }

    func update(forecast: DarkSkyForecast, foregroundColor: UIColor?, backgroundColor: UIColor?) {

        AppSettings.store(key: "units", value: forecast.unitsCode)

        //let foreColor = foregroundColor ?? UIColor.white
        let backColor = backgroundColor ?? UIColor.darkGray

        view.backgroundColor = backColor
    }

    @IBAction func switchUnits(_ sender: UIButton) {
        switch sender {
        case usButton:
            print("Use US units.")
            AppSettings.store(key: "units", value: "us")
            settingsLabel.text = "US units: ˚F, miles, mph, mbar"
        case ukButton:
            print("Use UK units.")
            AppSettings.store(key: "units", value: "uk2")
            settingsLabel.text = "UK units: ˚C, miles, mph, hPa"
        case caButton:
            print("Use CA units.")
            AppSettings.store(key: "units", value: "ca")
            settingsLabel.text = "CA units: ˚C, kilometers, km/h, mmHg"
        case siButton:
            print("Use SI units.")
            AppSettings.store(key: "units", value: "si")
            settingsLabel.text = "SI units: ˚C, metres, m/s, hPa"
        default:
            print("Use default units.")
            AppSettings.store(key: "units", value: "auto")
        }
    }
}
