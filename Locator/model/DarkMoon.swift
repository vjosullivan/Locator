//
//  DarkMoon.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 03/01/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import Foundation

/// Handles moon phase related calculations.
struct DarkMoon {

    private static let symbolCount = 28.0

    /// Given the phase of the moon, returns the appropriate "Weather Awesome" font's 
    /// representation of that phase.
    ///
    /// - Parameter phase: The moon phase as a continuous value between 0.0 and 1.0:
    ///   - 0.0 (minimum) New moon.
    ///   - 0.5 Full moon
    ///   - 1.0 (maximum) New moon.
    /// - Returns: A symbol from the "Weather Awesome" font that best represents the moon phase.
    ///
    static func symbol(from phase: Double) -> String {
        let base = 0xf095
        let offset = Int((phase + 0.5 / symbolCount) * symbolCount) % Int(symbolCount)
        return "\(UnicodeScalar(base + offset)!)"
    }

    /// Given the phase of the moon, returns the appropriate "Weather Awesome" font's
    /// **alternate** or **background** representation of that phase.
    ///
    /// - Parameter phase: The moon phase as a continuous value between 0.0 and 1.0:
    ///   - 0.0 (minimum) New moon.
    ///   - 0.5 Full moon
    ///   - 1.0 (maximum) New moon.
    /// - Returns: A symbol from the "Weather Awesome" font that best represents the moon phase.
    ///
    static func backgroundSymbol(from phase: Double) -> String {
        let base = 0xf0cf
        let offset = Int((phase + 0.5 / symbolCount) * symbolCount) % Int(symbolCount)
        // (The "new moon" symbol is not at offset == 0).
        return (offset == 0) ? "\u{f0eb}" : "\(UnicodeScalar(base + offset)!)"
    }

    private static var names = [
        "New\nmoon", "Growing\ncrescent", "First\nquarter", "Approaching\nfull",
        "Full\nmoon", "Past\nfull", "Last\nquarter", "Fading\ncrescent"]

    /// Returns a name for the given moon phase (e.g. "Full moon", "First quarter", etc.).
    ///
    /// - Parameter phase: The moon phase as a continuous value between 0.0 and 1.0:
    ///   - 0.0 (minimum) New moon.
    ///   - 0.5 Full moon
    ///   - 1.0 (maximum) New moon.
    /// - Returns: A name describing the moon's phase.
    ///
    static func name(from phase: Double) -> String {
        let nameCount = Double(names.count)
        let base = 0
        let offset = Int((phase + 0.5 / nameCount) * nameCount) % Int(nameCount)
        return names[base + offset]
    }
}
