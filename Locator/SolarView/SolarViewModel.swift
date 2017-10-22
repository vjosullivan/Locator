//
//  ViewModel.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 20/10/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import Foundation

class SolarViewModel: SolarViewRepresentable {
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

    private let clock: Clock

    init(with forecast: DarkSkyForecast, clock: Clock) {
        self.clock = clock

        sunriseTimeAtLocation = forecast.today?.sunriseTime?.asHMZ(timeZone: forecast.timeZone) ?? "No sunrise"
        sunsetTimeAtLocation  = forecast.today?.sunsetTime?.asHMZ(timeZone: forecast.timeZone) ?? "No sunset"
        if TimeZone.current.identifier != forecast.timeZone {
            sunriseTimeAtDevice = forecast.today?.sunriseTime?.asHMZ(timeZone: TimeZone.current.identifier) ?? ""
            sunsetTimeAtDevice  = forecast.today?.sunsetTime?.asHMZ(timeZone: TimeZone.current.identifier) ?? ""
        } else {
            sunriseTimeAtDevice = ""
            sunsetTimeAtDevice  = ""
        }

        sunriseIcon = (sunriseTimeAtLocation.isEmpty || forecast.today?.sunriseTime == nil)
            ? Weather.stars.symbol : Weather.sunrise.symbol
        sunsetIcon  = (sunsetTimeAtLocation.isEmpty || forecast.today?.sunsetTime == nil)
            ? Weather.stars.symbol : Weather.sunset.symbol

        sunHasRisenToday = clock.currentDateTime.isAfter(forecast.today?.sunriseTime ?? Date.distantFuture)
        sunHasSetToday   = clock.currentDateTime.isAfter(forecast.today?.sunsetTime ?? Date.distantFuture)

        timeToSunRiseOrSet = SolarViewModel.nextSunrise(
            now: clock.currentDateTime, sunrise: forecast.today?.sunriseTime, sunset: forecast.today?.sunsetTime)

        if let moonPhase = forecast.today?.moonPhase {
            moonPhaseIcon = DarkMoon.symbol(from: moonPhase)
            moonPhaseText = DarkMoon.name(from: moonPhase)
        } else {
            moonPhaseIcon = ""
            moonPhaseText = ""
        }
    }

    private static func nextSunrise(now: Date, sunrise: Date?, sunset: Date?) -> String {
        guard let sunrise = sunrise, let sunset = sunset else {
            return ""
        }
        if sunrise.isAfter(now) && (sunset.isAfter(sunrise) || now.isAfter(sunset)) {
            return timeToEvent(called: "Sunrise", at: sunrise, from: now)
        }
        if sunset.isAfter(now) && (sunrise.isAfter(sunset) || now.isAfter(sunrise)) {
            return timeToEvent(called: "Sunset", at: sunset, from: now)
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
    private static func timeToEvent(called name: String, at time: Date, from now: Date) -> String {
        guard time.isAfter(now) else {
            return ""
        }
        let minutes = Int(time.timeIntervalSince(now) / 60.0)
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
