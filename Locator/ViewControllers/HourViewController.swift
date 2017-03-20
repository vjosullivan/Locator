//
//  HourViewController.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 23/01/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class HourViewController: UIViewController {

    // These views have coloured backgrounds in the storyboard which are cleared when run.
    @IBOutlet var backgroundColoredViews: [UIView]!

    @IBOutlet weak var buttonTopLeft: UIButton!
    @IBOutlet weak var buttonTopRight: UIButton!
    @IBOutlet weak var buttonBottomLeft: UIButton!
    @IBOutlet weak var buttonBottomRight: UIButton!

    @IBOutlet weak var rainIntensityGraph: GraphView!
    @IBOutlet weak var tickStack: UIStackView!

    @IBOutlet weak var hourSummary: UILabel!
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

    func update(forecast: DarkSkyForecast, foregroundColor: UIColor?, backgroundColor: UIColor?) {
        minuteSummary.text = forecast.minutely?.summary ?? ""
        hourSummary.text   = forecast.hourly?.summary ?? ""

        rainIntensityGraph.data = forecast.minutelyRainIntensity

        view.backgroundColor = backgroundColor
    }

}
