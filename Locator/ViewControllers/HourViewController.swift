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
    @IBOutlet weak var rainProbabilityGraph: GraphView!

    @IBOutlet weak var hourSummary: UILabel!
    @IBOutlet weak var minuteSummary: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Clear background colors from labels and buttons
        _ = backgroundColoredViews.map { $0.backgroundColor = UIColor.clear }

        rainIntensityGraph.backgroundColor = UIColor(white: 0.33, alpha: 0.25)
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
        print("\n\nHOURS\n\n")
        minuteSummary.text = forecast.minutely?.summary ?? ""
        hourSummary.text   = forecast.hourly?.summary ?? ""

        print("Loading graphs...")
        rainIntensityGraph.invertGraph = true
        rainIntensityGraph.data = forecast.minutelyRainIntensity
        print("Rain intensity")
        dump(forecast.minutelyRainIntensity)
            // [0.1, 0.2, 0.3, 0.4, 0.5, 0.55, 0.56, 0.53, 0.47, 0.35, 0.25, 0.1, 0.05]
        //rainProbabilityGraph.invertGraph = false
        //rainProbabilityGraph.data = forecast.minutelyRainProbability
            // [0.1, 0.2, 0.3, 0.4, 0.5, 0.55, 0.56, 0.53, 0.47, 0.35, 0.25, 0.1, 0.05]
        print("Rain probability")
        dump(forecast.minutelyRainProbability)

        view.backgroundColor = backgroundColor
    }

}
