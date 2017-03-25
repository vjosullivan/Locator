//
//  HourViewController.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 23/01/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class HourViewController: UIViewController {

    var mainVC: MainViewController?

    // These views have coloured backgrounds in the storyboard which are cleared when run.
    @IBOutlet var backgroundColoredViews: [UIView]!

    @IBOutlet weak var buttonTopLeft: UIButton!
    @IBOutlet weak var labelTopLeft: UILabel!
    @IBOutlet weak var buttonTopRight: UIButton!
    @IBOutlet weak var labelTopRight: UILabel!
    @IBOutlet weak var buttonBottomLeft: UIButton!
    @IBOutlet weak var labelBottomLeft: UILabel!
    @IBOutlet weak var buttonBottomRight: UIButton!
    @IBOutlet weak var labelBottomRight: UILabel!

    @IBOutlet weak var rainIntensityGraph: GraphView!
    @IBOutlet weak var tickStack: UIStackView!

    @IBOutlet weak var graphTitle: UILabel!
    @IBOutlet weak var minuteSummary: UILabel!

    @IBOutlet weak var rainingLabel: UILabel!
    @IBOutlet weak var pouringLabel: UILabel!
    @IBOutlet weak var mizzlingLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Clear background colors from labels and buttons
        _ = backgroundColoredViews.map { $0.backgroundColor = UIColor.clear }

        rainIntensityGraph.backgroundColor = UIColor(white: 1.0, alpha: 0.50)
        rainIntensityGraph.layer.cornerRadius = 8
        rainIntensityGraph.layer.masksToBounds = true
        rainIntensityGraph.layer.borderColor = UIColor(white: 0.66, alpha: 0.25).cgColor
        rainIntensityGraph.layer.borderWidth = 1

        buttonTopLeft.layer.borderColor = UIColor.lightGray.cgColor
        buttonTopRight.layer.borderColor = UIColor.lightGray.cgColor
        buttonBottomLeft.layer.borderColor = UIColor.lightGray.cgColor
        buttonBottomRight.layer.borderColor = UIColor.lightGray.cgColor
    }

    func update(forecast: DarkSkyForecast, foregroundColor: UIColor?, backgroundColor: UIColor?,
                container: MainViewController) {

        mainVC = container

        graphTitle.text = precipitationType(from: forecast) + " in the next 60 mins."
        minuteSummary.text = oneHourSummary(from: forecast)
        rainIntensityGraph.data = forecast.minutelyRainIntensity
        view.backgroundColor = backgroundColor
    }

    private func oneHourSummary(from forecast: DarkSkyForecast) -> String {
        let summary: String
        if let oneHourSummary = forecast.minutely?.summary {
            summary = oneHourSummary
        } else if let currentSummary = forecast.current?.summary {
            summary = "Remaining \(currentSummary.lowercased()) for the next hour."
        } else {
            summary = ""
        }
        return summary
    }

    private func precipitationType(from forecast: DarkSkyForecast) -> String {
        if let type = forecast.current?.precipType {
            let first = String(type.characters.prefix(1)).capitalized
            let other = String(type.characters.dropFirst())
            return first + other
        } else {
            return "No precipitation"
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
        case sender == buttonTopLeft: // 24 hour forecast
            mainVC.flip(mainVC.hourPanel, rearView: mainVC.dayPanel)
        case sender == buttonTopRight: // 7 day forecast
            mainVC.flip(mainVC.hourPanel, rearView: mainVC.weekPanel)
        case sender == buttonBottomLeft: // Weather alerts
            mainVC.flip(mainVC.hourPanel, rearView: mainVC.alertsPanel)
        case sender == buttonBottomRight: // Credits
            mainVC.flip(mainVC.hourPanel, rearView: mainVC.creditsPanel)
        default:
            break
        }
    }
}
