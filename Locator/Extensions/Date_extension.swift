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
        if let timezone = timezone {
            let tz      = TimeZone(identifier: timezone)
            formatter.timeZone = tz
            formatter.dateFormat = twentyFourHourClock ? "HH:mm zz" : "h:mm a zz"
        } else {
            formatter.dateFormat = twentyFourHourClock ? "HH:mm zz" : "h:mm a zz"
        }
        return formatter.string(from: self)
    }

    func asHMZ(timeZone: String? = nil) -> String {
        let zone = TimeZone(identifier: timeZone ?? "") ?? TimeZone.current

        let f1 = DateFormatter()
        f1.timeZone  = zone
        f1.timeStyle = .short
        return "\(f1.string(from: self).lowercased()) \(zone.localisedAbbreviation())"
    }

    func asHpm(showMidday: Bool = false) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        let time = formatter.string(from: self).lowercased()
        if showMidday {
            if time == "12pm" {
                return "midday"
            } else if time == "12am" {
                return "midnight"
            }
        }
        return time
    }

    func isAfter(_ date: Date) -> Bool {
        return self.compare(date) != ComparisonResult.orderedDescending
    }

    ///  Returns the exact date for the start of today.
    ///
    static func startOfToday() -> Date {
        var cal = Calendar(identifier: Calendar.Identifier.gregorian)
        cal.timeZone = TimeZone.autoupdatingCurrent
        let components = (cal as NSCalendar).components([.day, .month, .year ], from: Date())
        return cal.date(from: components)!
    }
}
