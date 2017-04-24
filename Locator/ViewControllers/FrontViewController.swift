//
//  FrontViewController.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 17/01/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class FrontViewController: UIViewController {

    static let id = "FrontViewControllerID"

    var presenter: FrontViewPresenter?

    var mainVC: MainViewController?

    // These views have coloured backgrounds in the storyboard which are cleared when run.
    @IBOutlet var backgroundColoredViews: [UIView]!

    @IBOutlet weak var buttonATR: UIButton!
    @IBOutlet weak var buttonATL: UIButton!
    @IBOutlet weak var buttonABR: UIButton!
    @IBOutlet weak var buttonABL: UIButton!

    @IBOutlet weak var currentWeatherValue: UILabel!
    @IBOutlet weak var currentTemperatureValue: UILabel!
    @IBOutlet weak var minTempValue: UILabel!
    @IBOutlet weak var minTempTime: UILabel!
    @IBOutlet weak var maxTempValue: UILabel!
    @IBOutlet weak var maxTempTime: UILabel!

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        presenter?.viewCreated(view: self)
    }

    func configure(presenter: FrontViewPresenter,
                   backgroundColor: UIColor,
                   cornerRadius: CGFloat,
                   container: MainViewController) {

        self.presenter = presenter
        view.backgroundColor = backgroundColor
        view.topCornerRadius = cornerRadius
        mainVC = container

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

        let foregroundColor = backgroundColor.darker
        currentTemperatureValue.textColor = foregroundColor
        currentWeatherValue.textColor = foregroundColor

        buttonATL.setTitleColor(foregroundColor, for: .normal)
        buttonATR.setTitleColor(foregroundColor, for: .normal)
        buttonABL.setTitleColor(foregroundColor, for: .normal)
        buttonABR.setTitleColor(foregroundColor, for: .normal)
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

protocol FrontView {
    func updateEarlyMinMax(_ temperature: String, at time: String, highlight: Bool)
    func updateLateMinMax(_ temperature: String, at time: String, highlight: Bool)
    func updateCurrentWeather(temperature: String, weather: String)
}

extension FrontViewController: FrontView {

    func updateEarlyMinMax(_ temperature: String, at time: String, highlight: Bool) {
        minTempValue.text = temperature
        minTempValue.textColor = (highlight) ? UIColor.amber : currentTemperatureValue.textColor

        minTempTime.text = time
        minTempTime.textColor = minTempValue.textColor
    }

    func updateLateMinMax(_ temperature: String, at time: String, highlight: Bool) {
        maxTempValue.text = temperature
        maxTempValue.textColor = (highlight) ? UIColor.amber : currentTemperatureValue.textColor

        maxTempTime.text = time
        maxTempTime.textColor = maxTempValue.textColor
    }

    func updateCurrentWeather(temperature: String, weather: String) {
        currentTemperatureValue.text = temperature
        currentWeatherValue.text = weather
    }
}
