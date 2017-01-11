//
//  SolarViewController.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 29/12/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class SolarViewController: UIViewController {

    @IBOutlet weak var returnButton: UIButton!

    @IBOutlet weak var sunriseSymbol: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunriseTimeThere: UILabel!
    @IBOutlet weak var sunriseTimeHere: UILabel!

    @IBOutlet weak var sunsetSymbol: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var sunsetTimeThere: UILabel!
    @IBOutlet weak var sunsetTimeHere: UILabel!

    @IBOutlet weak var moonSymbol: UILabel!
    @IBOutlet weak var moonBackground: UILabel!
    @IBOutlet weak var moonLabel: UILabel!
    @IBOutlet weak var moonName: UILabel!

    var mainVC: MainViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Solar viewDidLoad")
    }

    func update(forecast: DarkSkyForecast, foregroundColor: UIColor?, backgroundColor: UIColor?) {

        let foreColor = foregroundColor ?? UIColor.white
        let backColor = backgroundColor ?? UIColor.darkGray

        print("Updating solar dispalay")
        updateSunrise(time: forecast.today?.sunriseTime, timeZone: forecast.timeZone, textColor: foreColor)
        updateSunset(time: forecast.today?.sunsetTime, timeZone: forecast.timeZone, textColor: foreColor)

        sunriseLabel.textColor     = foreColor
        sunriseTimeThere.textColor = foreColor
        sunriseTimeHere.textColor  = foreColor
        sunsetLabel.textColor     = foreColor
        sunsetTimeThere.textColor = foreColor
        sunsetTimeHere.textColor  = foreColor

        if let moonPhase = forecast.today?.moonPhase {
            moonSymbol.text      = DarkMoon.symbol(from: moonPhase)
            moonSymbol.textColor = UIColor(white: 1.0, alpha: 0.9)
            moonBackground.text      = "\u{F0EB}" //DarkMoon.backgroundSymbol(from: moonPhase)
            moonBackground.textColor = UIColor(white: 0.8, alpha: 0.5)
            moonLabel.text      = "Moon"
            moonLabel.textColor = foreColor
            moonName.text      = DarkMoon.name(from: moonPhase)
            moonName.textColor = foreColor
        } else {
            moonSymbol.text = ""
            moonLabel.text  = ""
            moonName.text   = ""
        }

        returnButton.setTitleColor(foreColor, for: .normal)
        view.backgroundColor = backColor
    }

    private func updateSunrise(time: Date?, timeZone identifier: String, textColor: UIColor) {
        if let sunrise = time {
            sunriseSymbol.text = "\u{F051}"
            let sunriseTheirTime = sunrise.asHMZ(timeZone: identifier)
            sunriseTimeThere.text = sunriseTheirTime
            let sunriseOurTime = sunrise.asHMZ(timeZone: TimeZone.current.identifier)
            if sunriseTheirTime.substring(0..<5) != sunriseOurTime.substring(0..<5) {
                sunriseTimeHere.text  = "(\(sunriseOurTime))"
            } else {
                sunriseTimeHere.text  = ""
            }
            sunriseSymbol.textColor = Date().isAfter(sunrise) ? UIColor.amber : textColor
        } else {
            sunriseSymbol.text      = "\u{F077}"
            sunriseSymbol.textColor = UIColor.amber
            sunriseTimeThere.text = "No sunrise"
            sunriseTimeHere.text  = ""
        }
    }

    private func updateSunset(time: Date?, timeZone identifier: String?, textColor: UIColor) {
        if let sunset = time {
            sunsetSymbol.text = "\u{F052}"
            let sunsetTheirTime = sunset.asHMZ(timeZone: identifier)
            let sunsetOurTime   = sunset.asHMZ(timeZone: TimeZone.current.identifier)
            sunsetTimeThere.text = sunsetTheirTime
            if sunsetTheirTime.substring(0..<5) != sunsetOurTime.substring(0..<5) {
                sunsetTimeHere.text  = "(\(sunsetOurTime))"
            } else {
                sunsetTimeHere.text  = ""
            }
            sunsetSymbol.textColor = Date().isAfter(sunset) ? UIColor.amber : textColor
        } else {
            sunsetSymbol.text      = "\u{F077}"
            sunsetSymbol.textColor = UIColor.amber
            sunsetTimeThere.text = "No sunset"
            sunsetTimeHere.text  = ""
        }

    }
}
