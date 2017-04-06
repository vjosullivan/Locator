//
//  DayViewController.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 23/01/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class DayViewController: UIViewController {

    var mainVC: MainViewController?

    @IBOutlet weak var titleBar: UILabel!

    @IBOutlet weak var weatherTable: UITableView!

    @IBOutlet weak var buttonTopLeft: UIButton!
    @IBOutlet weak var buttonTopRight: UIButton!
    @IBOutlet weak var buttonBottomLeft: UIButton!
    @IBOutlet weak var buttonBottomRight: UIButton!

    @IBOutlet weak var summary: UILabel!

    private var weatherHandler = WeatherHandler()

    override func viewDidLoad() {
        super.viewDidLoad()

        buttonTopLeft.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi / 2.0)
        buttonTopRight.transform = CGAffineTransform.init(rotationAngle: -CGFloat.pi / 2.0)
        buttonBottomLeft.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi / 2.0)
        buttonBottomRight.transform = CGAffineTransform.init(rotationAngle: -CGFloat.pi / 2.0)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        weatherTable.dataSource = weatherHandler
        weatherTable.delegate = weatherHandler
    }

    func update(forecast: DarkSkyForecast, backgroundColor: UIColor, cornerRadius: CGFloat, container: MainViewController) {
        let foregroundColor = backgroundColor.darker
        mainVC = container

        titleBar.textColor = foregroundColor
        buttonTopLeft.setTitleColor(foregroundColor, for: .normal)
        buttonTopRight.setTitleColor(foregroundColor, for: .normal)
        buttonBottomLeft.setTitleColor(foregroundColor, for: .normal)
        buttonBottomRight.setTitleColor(foregroundColor, for: .normal)

        updateText(on: buttonBottomLeft, from: forecast)
        weatherHandler.update(forecast: forecast, detailType: .day )
        weatherTable.reloadData()

        summary.textColor = foregroundColor
        summary.text = forecast.hourly?.summary ?? ""

        view.backgroundColor = backgroundColor
        view.bottomCornerRadius = cornerRadius
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
        case sender == buttonTopLeft: // 24 hour forecast
            mainVC.flip(mainVC.dayPanel, rearView: mainVC.hourPanel)
        case sender == buttonTopRight: // 7 day forecast
            mainVC.flip(mainVC.dayPanel, rearView: mainVC.weekPanel)
        case sender == buttonBottomLeft: // Weather alerts
            mainVC.flip(mainVC.dayPanel, rearView: mainVC.alertsPanel)
        case sender == buttonBottomRight: // Credits
            mainVC.flip(mainVC.dayPanel, rearView: mainVC.creditsPanel)
        default:
            break
        }
    }

    // MARK: - Internal functions.

    private func updateText(on button: UIButton, from forecast: DarkSkyForecast) {
        if let alerts = forecast.alerts {
            let plural = alerts.count == 1 ? "" : "s"
            button.setTitle("\(alerts.count.asText.capitalized) Alert\(plural)", for: .normal)
            button.setTitleColor(UIColor.yellow, for: .normal)
        } else {
            button.setTitle("No Alerts", for: .normal)
        }
    }
}
