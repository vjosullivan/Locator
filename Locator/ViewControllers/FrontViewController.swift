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
    @IBOutlet weak var labelATR: UILabel!
    @IBOutlet weak var buttonATL: UIButton!
    @IBOutlet weak var labelATL: UILabel!
    @IBOutlet weak var buttonABR: UIButton!
    @IBOutlet weak var labelABR: UILabel!
    @IBOutlet weak var buttonABL: UIButton!
    @IBOutlet weak var labelABL: UILabel!

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

        buttonATR.layer.borderColor = UIColor.lightGray.cgColor
        buttonABR.layer.borderColor = UIColor.lightGray.cgColor
        buttonATL.layer.borderColor = UIColor.lightGray.cgColor
        buttonABL.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        placeVertical(text: "Settings", on: buttonATL, using: labelATL)
        placeVertical(text: "Location", on: buttonATR, using: labelATR, rotateClockwise: false)
        placeVertical(text: "Daylight", on: buttonABL, using: labelABL)
        placeVertical(text: "Details", on: buttonABR, using: labelABR, rotateClockwise: false)
    }

    private func placeVertical(text: String, on button: UIButton, using label: UILabel, rotateClockwise: Bool = true) {
        label.frame = CGRect(x: 0.0, y: 0.0, width: button.frame.width, height: button.frame.height)
        button.addSubview(label)
        let angle = rotateClockwise ? CGFloat.pi / 2.0 : -CGFloat.pi / 2.0  // +/- 90°.
        label.transform = CGAffineTransform.init(rotationAngle: angle)
        //label.textColor = button.currentTitleColor
        label.backgroundColor = UIColor.clear
        label.text = text
        label.font = button.titleLabel?.font.withSize(14)
        label.textAlignment = .center
    }

    func update(forecast: DarkSkyForecast, foregroundColor: UIColor?, backgroundColor: UIColor?,
                container: MainViewController) {
        mainVC = container

        viewA.backgroundColor = backgroundColor
        currentTemperatureValue.textColor = foregroundColor
        currentWeatherValue.textColor = foregroundColor
        labelATR.textColor = foregroundColor
        labelATL.textColor = foregroundColor
        labelABR.textColor = foregroundColor
        labelABL.textColor = foregroundColor
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

        //let foreColor = foregroundColor ?? UIColor.white
        let backColor = backgroundColor ?? UIColor.darkGray

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
            if minTime.isAfter(maxTime) {
                print("Switch temperatures because min@\(minTime) : max@\(maxTime).")
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
            } else {
                print("No switch temperatures because \(minTime):\(maxTime).")
            }
        }
    }

    // MARK: - Actions

    @IBAction func flip(_ sender: UIButton) {
        guard let mainVC = mainVC else {
            return
        }
        switch true {
        case sender == buttonATL:
            mainVC.flip(mainVC.frontPanel, rearView: mainVC.settingsPanel)
        case sender == buttonABL:
            mainVC.flip(mainVC.frontPanel, rearView: mainVC.solarPanel)
        case sender == buttonABR:
            mainVC.flip(mainVC.frontPanel, rearView: mainVC.detailsPanel)
        default:
            break
        }
    }

    @IBAction func selectLocation(_ sender: UIButton) {
        mainVC?.performSegue(withIdentifier: "segueToLocationList", sender: nil)
    }
}
