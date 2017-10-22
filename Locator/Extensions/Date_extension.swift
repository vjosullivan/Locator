//
//  Date_extension.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 03/01/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import Foundation

extension Date {

    func asYYYYMMDD() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }

    func asHHMM(twentyFourHourClock: Bool = true, timezone: String? = nil) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = twentyFourHourClock ? "HH:mm " : "h:mm a "
        let suffix: String
        if let timezone = timezone,
            let tz      = TimeZone(identifier: timezone) {
            formatter.timeZone = tz
            suffix = (tz.secondsFromGMT() != TimeZone.current.secondsFromGMT())
                ? tz.localisedAbbreviation() : ""
        } else {
            suffix = ""
        }
        return formatter.string(from: self) + suffix
    }

    func asHMZ(timeZone: String? = nil) -> String {
        guard let zone = TimeZone(identifier: timeZone ?? "") else { return "" }

        let f1 = DateFormatter()
        f1.timeZone  = zone
        f1.timeStyle = .short
        return "\(f1.string(from: self).lowercased()) \(zone.localisedAbbreviation())"
    }

    func asDDD(timeZone identifier: String? = "") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        formatter.timeZone = getTimeZone(identifier: identifier)
        let time = formatter.string(from: self).lowercased()
        return time.capitalized
    }

    func asHpm(showMidday: Bool = false, timeZone identifier: String? = "") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        formatter.timeZone = getTimeZone(identifier: identifier)
        let time = formatter.string(from: self).lowercased()
        if showMidday {
            if time == "12pm" {
                return "Noon"
            } else if time == "12am" {
                return "Night"
            }
        }
        return time
    }

    func isAfter(_ date: Date) -> Bool {
        return self.timeIntervalSinceReferenceDate > date.timeIntervalSinceReferenceDate
    }

    ///  Returns the exact date for the start of today.
    ///
    static func startOfToday() -> Date {
        var cal = Calendar(identifier: Calendar.Identifier.gregorian)
        cal.timeZone = TimeZone.autoupdatingCurrent
        let components = (cal as NSCalendar).components([.day, .month, .year ], from: Date())
        return cal.date(from: components)!
    }

    /// Given an (optional) time zone identifier (e.g. "London/Europe"), returns the correspomding `TimeZone`,
    /// otherwise the local `TimeZone`.
    ///
    /// - Parameter identifier: A time zone identifier (e.g. "London/Europe").
    /// - Returns: If matched, the appropriate `TimeZone`, otherwise the current/local one.
    ///
    private func getTimeZone(identifier: String?) -> TimeZone {
        guard identifier != nil else {
            return Calendar.current.timeZone
        }
        let zone = TimeZone(identifier: identifier!)
        return zone ?? Calendar.current.timeZone
    }
}
