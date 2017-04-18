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

    @IBOutlet weak var nextSunriseLabel: UILabel!

    @IBOutlet weak var moonSymbol: UILabel!
    @IBOutlet weak var moonBackground: UILabel!
    @IBOutlet weak var moonName: UILabel!

//    var mainVC: MainViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func update(forecast: DarkSkyForecast, backgroundColor: UIColor, cornerRadius: CGFloat) {
        let foregroundColor = backgroundColor.darker

        updateSunrise(time: forecast.today?.sunriseTime, timeZone: forecast.timeZone, textColor: foregroundColor)
        updateSunset(time: forecast.today?.sunsetTime, timeZone: forecast.timeZone, textColor: foregroundColor)
        nextSunriseLabel.text = nextSunrise(sunrise: forecast.today?.sunriseTime, sunset: forecast.today?.sunsetTime)

        sunriseLabel.textColor     = foregroundColor
        sunriseTimeThere.textColor = foregroundColor
        sunriseTimeHere.textColor  = foregroundColor
        sunsetLabel.textColor     = foregroundColor
        sunsetTimeThere.textColor = foregroundColor
        sunsetTimeHere.textColor  = foregroundColor
        nextSunriseLabel.textColor = foregroundColor

        if let moonPhase = forecast.today?.moonPhase {
            moonSymbol.text      = DarkMoon.symbol(from: moonPhase)
            moonSymbol.textColor = UIColor(white: 1.0, alpha: 0.9)
            moonBackground.text  = Weather.newMoonAlt.symbol
            moonBackground.textColor = UIColor(white: 0.8, alpha: 0.5)
            moonName.text      = DarkMoon.name(from: moonPhase)
            moonName.textColor = foregroundColor
        } else {
            moonSymbol.text = ""
            moonName.text   = ""
        }

        returnButton.setTitleColor(foregroundColor, for: .normal)
        view.backgroundColor = backgroundColor
        view.topCornerRadius = cornerRadius
    }

    private func nextSunrise(sunrise: Date?, sunset: Date?) -> String {
        guard let sunrise = sunrise, let sunset = sunset else {
            return ""
        }
        let now = Date()
        if sunrise.isAfter(now) && (sunset.isAfter(sunrise) || now.isAfter(sunset)) {
            return timeToEvent(called: "Sunrise", at: sunrise)
        }
        if sunset.isAfter(now) && (sunrise.isAfter(sunset) || now.isAfter(sunrise)) {
            return timeToEvent(called: "Sunset", at: sunset)
        }
        return ""
    }

    /// Return a longhand description of the time remaining until the named event occurs.
    ///
    /// - Parameters:
    ///   - name: The name of the event (e.g. "Sunrise")
    ///   - time: The date of the occurrence of the event.  
    ///           If the date is not a future date, an empty `String` is returned.
    /// - Returns: A longhand description of the time remaining to the named event.
    ///
    private func timeToEvent(called name: String, at time: Date) -> String {
        let now = Date()
        guard time.isAfter(now) else {
            return ""
        }
        let minutes = Int(time.timeIntervalSince(Date()) / 60.0)
        if minutes < 60 {
            let plural = minutes == 1 ? "" : "s"
            return "\(name) in \(minutes) minute\(plural)."
        }
        var hours = minutes / 60
        let preposition: String
        switch (minutes % 60) {
        case 1...5:
            preposition = "About"
        case 6...15:
            preposition = "Just over"
        case 16...30:
            preposition = "Well over"
        case 31...45:
            preposition = "Well under"
            hours += 1
        case 46...55:
            preposition = "Under"
            hours += 1
        case 56...59:
            preposition = "Just under"
            hours += 1
        default:
            preposition = "almost exactly"
        }
        let plural = hours == 1 ? "" : "s"

        return "\(preposition) \(hours) hour\(plural) to \(name)."
    }

    private func updateSunrise(time: Date?, timeZone: String?, textColor: UIColor) {
        update(symbol: sunriseSymbol, theirTime: sunriseTimeThere, ourTime: sunriseTimeHere,
               eventTime: time, timeZone: timeZone, textColor: textColor, icon: Weather.sunrise.symbol)
    }

    private func updateSunset(time: Date?, timeZone: String?, textColor: UIColor) {
        update(symbol: sunsetSymbol, theirTime: sunsetTimeThere, ourTime: sunsetTimeHere,
               eventTime: time, timeZone: timeZone, textColor: textColor, icon: Weather.sunset.symbol)
    }

    private func update(symbol: UILabel, theirTime: UILabel, ourTime: UILabel,
                        eventTime: Date?, timeZone identifier: String?, textColor: UIColor, icon: String) {
        if let eventTime = eventTime {
            symbol.text = icon
            let eventTheirTime = eventTime.asHMZ(timeZone: identifier)
            let eventOurTime   = eventTime.asHMZ(timeZone: TimeZone.current.identifier)
            theirTime.text = eventTheirTime
            if eventTheirTime.substring(0..<5) != eventOurTime.substring(0..<5) {
                ourTime.text  = "(\(eventOurTime))"
            } else {
                ourTime.text  = ""
            }
            symbol.textColor = Date().isAfter(eventTime) ? textColor : UIColor.amber
        } else {
            symbol.text      = Weather.stars.symbol
            symbol.textColor = textColor
            theirTime.text = "None"
            ourTime.text = ""
        }
    }
}
