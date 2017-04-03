//
//  FrontViewController.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 17/01/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import Foundation

import UIKit

class FrontViewController: UIViewController {

    var mainVC: MainViewController?

    // These views have coloured backgrounds in the storyboard which are cleared when run.
    @IBOutlet var backgroundColoredViews: [UIView]!

    @IBOutlet weak var buttonATR: UIButton!
    @IBOutlet weak var buttonATL: UIButton!
    @IBOutlet weak var buttonABR: UIButton!
    @IBOutlet weak var buttonABL: UIButton!

    @IBOutlet weak var viewA: UIView!
    @IBOutlet weak var currentWeatherValue: UILabel!
    @IBOutlet weak var currentTemperatureValue: UILabel!
    @IBOutlet weak var minTempValue: UILabel!
    @IBOutlet weak var minTempTime: UILabel!
    @IBOutlet weak var maxTempValue: UILabel!
    @IBOutlet weak var maxTempTime: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Clear background colors from labels and buttons
        _ = backgroundColoredViews.map { $0.backgroundColor = UIColor.clear }

        buttonATL.setTitle("Settings", for: .normal)
        buttonATR.setTitle("Location", for: .normal)
        buttonABL.setTitle("Daylight", for: .normal)
        buttonABR.setTitle("Details", for: .normal)
        buttonATL.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi / 2.0)
        buttonATR.transform = CGAffineTransform.init(rotationAngle: -CGFloat.pi / 2.0)
        buttonABL.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi / 2.0)
        buttonABR.transform = CGAffineTransform.init(rotationAngle: -CGFloat.pi / 2.0)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    func update(forecast: DarkSkyForecast, foregroundColor: UIColor?, backgroundColor: UIColor?,
                container: MainViewController) {
        mainVC = container

        viewA.backgroundColor = backgroundColor
        currentTemperatureValue.textColor = foregroundColor
        currentWeatherValue.textColor = foregroundColor
        minTempValue.textColor = foregroundColor
        minTempTime.textColor = foregroundColor
        maxTempValue.textColor = foregroundColor
        maxTempTime.textColor = foregroundColor

        if let temperature = forecast.current?.temperature {
            currentTemperatureValue.text  = "\(Int(round(temperature.value)))\(temperature.unit.symbol)"
        } else {
            currentTemperatureValue.text  = ""
        }
        if let summary = forecast.current?.summary {
            currentWeatherValue.text = "\(summary)"
        } else {
            currentWeatherValue.text = "No weather!"
        }

        setMinMaxTemperatures(forecast: forecast, textColor: foregroundColor!)

        let foreColor = foregroundColor ?? UIColor.white
        let backColor = backgroundColor ?? UIColor.darkGray

        buttonATL.setTitleColor(foreColor, for: .normal)
        buttonATR.setTitleColor(foreColor, for: .normal)
        buttonABL.setTitleColor(foreColor, for: .normal)
        buttonABR.setTitleColor(foreColor, for: .normal)
        view.backgroundColor = backColor
    }

    private func setMinMaxTemperatures(forecast: DarkSkyForecast, textColor: UIColor) {
        if let hi = forecast.today?.temperatureMax {
            maxTempValue.text = "High \(Int(hi.value))\(hi.unit.symbol)"
            if let maxTime = forecast.today?.temperatureMaxTime {
                maxTempTime.text = maxTime.asHHMM(timezone: forecast.timeZone)
                maxTempTime.textColor = Date().isAfter(maxTime) ? UIColor.gray : textColor
            } else {
                maxTempTime.textColor = textColor
            }
            maxTempValue.textColor = maxTempTime.textColor
        } else {
            maxTempValue.text = ""
            maxTempTime.text = ""
        }
        if let lo = forecast.today?.temperatureMin {
            minTempValue.text = "Low \(Int(lo.value))\(lo.unit.symbol)"
            if let minTime = forecast.today?.temperatureMinTime {
                minTempTime.text = minTime.asHHMM(timezone: forecast.timeZone)
                minTempTime.textColor = Date().isAfter(minTime) ? UIColor.gray : textColor
            } else {
                minTempTime.textColor = textColor
            }
            minTempValue.textColor = minTempTime.textColor
        } else {
            minTempValue.text = ""
            minTempTime.text = ""
        }
        if let maxTime = forecast.today?.temperatureMaxTime,
            let minTime = forecast.today?.temperatureMinTime {
            // Put the earlier min/max time on the left.
            if minTime.isAfter(maxTime) {
                let tempValue = minTempValue.text
                let tempTime = minTempTime.text
                let tempColor = minTempValue.textColor
                minTempValue.text = maxTempValue.text
                minTempValue.textColor = maxTempValue.textColor
                minTempTime.text = maxTempTime.text
                minTempTime.textColor = maxTempTime.textColor
                maxTempValue.text = tempValue
                maxTempValue.textColor = tempColor
                maxTempTime.text = tempTime
                maxTempTime.textColor = tempColor
            }
        }
    }

    // MARK: - Actions

    /// Calls an automated action the "flips" between two displayed screens.  The particular screen revealed
    /// is dependent upon the button calling the action.
    ///
    /// - Parameter sender: The button requesting the action.
    ///
    @IBAction func flip(_ sender: UIButton) {
        guard let mainVC = mainVC else {
            return
        }
        switch true {
        case sender == buttonATL: // Settings
            mainVC.flip(mainVC.frontPanel, rearView: mainVC.settingsPanel)
        case sender == buttonABL: // Daylight
            mainVC.flip(mainVC.frontPanel, rearView: mainVC.solarPanel)
        case sender == buttonABR: // Details
            mainVC.flip(mainVC.frontPanel, rearView: mainVC.detailsPanel)
        default:
            break
        }
    }

    @IBAction func selectLocation(_ sender: UIButton) {
        mainVC?.performSegue(withIdentifier: "segueToLocationList", sender: nil)
    }
}
