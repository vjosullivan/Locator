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
    @IBOutlet weak var todaysHighValue: UILabel!
    @IBOutlet weak var todaysLowValue: UILabel!
    @IBOutlet weak var highIcon: UILabel!
    @IBOutlet weak var lowIcon: UILabel!

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
        let angle = rotateClockwise ? CGFloat(M_PI_2) : -CGFloat(M_PI_2)  // +/- 90°.
        label.transform = CGAffineTransform.init(rotationAngle: angle)
        //label.textColor = button.currentTitleColor
        label.backgroundColor = UIColor.clear
        label.text = text
        label.font = button.titleLabel?.font
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
        todaysHighValue.textColor = foregroundColor
        todaysLowValue.textColor = foregroundColor
        highIcon.textColor = UIColor.red
        lowIcon.textColor = UIColor.blue

        if let temperature = forecast.current?.temperature {
            currentTemperatureValue.text  = "\(Int(round(temperature.value)))\(temperature.unit.symbol)"
        } else {
            currentTemperatureValue.text  = ""
        }
        if let summary = forecast.current?.summary {
            currentWeatherValue.text = "\(summary)"
        } else {
            currentWeatherValue.text = "Unknown."
        }
        if let hi = forecast.today?.apparentTemperatureMax {
            todaysHighValue.text = "\(Int(hi.value))\(hi.unit.symbol)"
            highIcon.text = "\u{F055}"
        } else {
            todaysHighValue.text = " "
            highIcon.text = " "
        }
        if let lo = forecast.today?.apparentTemperatureMin {
            todaysLowValue.text = "\(Int(lo.value))\(lo.unit.symbol)"
            lowIcon.text = "\u{F053}"
        } else {
            todaysLowValue.text = " "
            lowIcon.text = " "
        }

        //let foreColor = foregroundColor ?? UIColor.white
        let backColor = backgroundColor ?? UIColor.darkGray

        view.backgroundColor = backColor

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
