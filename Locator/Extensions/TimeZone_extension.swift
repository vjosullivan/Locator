//
//  TimeZone_extension.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 09/01/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import Foundation

extension TimeZone {
    
    /// Return the timezone name (e.g. Central European Time) as a set of initials (e.g. CET).
    /// If there is a summer/daylight savings form apllying then that is used.  If the summer
    /// form is given as a GMT offset then there is no actual summer time and the standard form is used.
    ///
    /// - Returns: The abbreviated name of the time zone (avoiding using GMT offset if at all possible).
    ///
    func localisedAbbreviation() -> String {
        let name: String
        if self.isDaylightSavingTime() {
            let summerName = self.localizedName(for: .daylightSaving, locale: Locale.current)!
            name = (String(summerName.characters.prefix(3)) != "GMT") ? summerName : self.localizedName(for: .standard, locale: Locale.current)!
        } else {
            name = self.localizedName(for: .standard, locale: Locale.current)!
        }
        if name.characters.count > 3 && String(name.characters.prefix(3)) != "GMT" {
            return name.components(separatedBy: " ").reduce("") {$0 + String($1[$1.startIndex]) }
        } else {
            return name
        }
    }
}
