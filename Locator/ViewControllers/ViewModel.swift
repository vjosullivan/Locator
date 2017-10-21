//
//  ViewModel.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 20/10/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import Foundation

protocol SolarViewModel {
    /// The local time of sunrise at the given forecast location.
    var sunriseTimeAtLocation: String { get }
    /// The local time of sunrise at the device running this app.
    var sunriseTimeAtDevice: String { get }
    /// The icon to be displayed, either for sunrise or for no sunrise.
    var sunriseIcon: String { get }
    /// The icon to be displayed, either for sunset or for no sunset.
    var sunsetIcon: String { get }
    /// The local time of sunset at the given forecast location.
    var sunsetTimeAtLocation: String { get }
    /// The local time of sunset at the device running this app.
    var sunsetTimeAtDevice: String { get }
    /// `true` if sunrise has already occurred today, otherwise `false`.
    var sunHasRisenToday: Bool { get }
    /// `true` if sunset has already occurred today, otherwise `false`.
    var sunHasSetToday: Bool { get }
    /// The amount of time left until the next sunrise or sunset today.
    var timeToSunRiseOrSet: String { get }
    /// The icon to be displayed to show the moon phase.
    var moonPhaseIcon: String { get }
    /// The text to be displayed to describle the moon phase.
    var moonPhaseText: String { get }
}

class ViewModel: SolarViewModel {
    var sunriseTimeAtLocation: String
    var sunriseTimeAtDevice: String
    var sunriseIcon: String
    var sunHasRisenToday: Bool

    var sunsetTimeAtLocation: String
    var sunsetTimeAtDevice: String
    var sunsetIcon: String
    var sunHasSetToday: Bool

    var timeToSunRiseOrSet: String

    var moonPhaseIcon: String
    var moonPhaseText: String

    init(with forecast: DarkSkyForecast) {
        sunriseTimeAtLocation = forecast.today?.sunriseTime?.asHMZ(timeZone: forecast.timeZone) ?? "None"
        sunsetTimeAtLocation  = forecast.today?.sunsetTime?.asHMZ(timeZone: forecast.timeZone) ?? "None"
        if TimeZone.current.identifier != forecast.timeZone {
            sunriseTimeAtDevice = forecast.today?.sunriseTime?.asHMZ(timeZone: TimeZone.current.identifier) ?? ""
            sunsetTimeAtDevice  = forecast.today?.sunsetTime?.asHMZ(timeZone: TimeZone.current.identifier) ?? ""
        } else {
            sunriseTimeAtDevice = " "
            sunsetTimeAtDevice  = " "
        }

        sunriseIcon = (forecast.today?.sunriseTime != nil) ? Weather.sunrise.symbol : Weather.stars.symbol
        sunsetIcon  = (forecast.today?.sunsetTime != nil) ? Weather.sunset.symbol : Weather.stars.symbol

        sunHasRisenToday = Date().isAfter(forecast.today?.sunriseTime ?? Date.distantFuture)
        sunHasSetToday   = Date().isAfter(forecast.today?.sunsetTime ?? Date.distantFuture)

        timeToSunRiseOrSet = ViewModel.nextSunrise(sunrise: forecast.today?.sunriseTime, sunset: forecast.today?.sunsetTime)

        if let moonPhase = forecast.today?.moonPhase {
            moonPhaseIcon = DarkMoon.symbol(from: moonPhase)
            moonPhaseText = DarkMoon.name(from: moonPhase)
        } else {
            moonPhaseIcon = ""
            moonPhaseText = ""
        }
    }

    private static func nextSunrise(sunrise: Date?, sunset: Date?) -> String {
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
    private static func timeToEvent(called name: String, at time: Date) -> String {
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
            preposition = "Over"
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
}
