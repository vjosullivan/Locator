//
//  DarkMoon.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 03/01/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import Foundation

struct DarkMoon {

    private static let symbolCount = 28.0

    /// <#Description#>
    ///
    /// - Parameter phase: <#phase description#>
    /// - Returns: <#return value description#>
    static func symbol(from phase: Double) -> String {
        let base = 0xf095
        let offset = Int((phase + 0.5 / symbolCount) * symbolCount) % Int(symbolCount)
        return "\(UnicodeScalar(base + offset)!)"
    }

    /// <#Description#>
    ///
    /// - Parameter phase: <#phase description#>
    /// - Returns: <#return value description#>
    static func backgroundSymbol(from phase: Double) -> String {
        let base = 0xf0cf
        let offset = Int((phase + 0.5 / symbolCount) * symbolCount) % Int(symbolCount)
        return (offset == 0) ? "\u{f0eb}" : "\(UnicodeScalar(base + offset)!)"
    }

    private static var names = [
        "New\nmoon", "Growing\ncrescent", "First\nquarter", "Approaching\nfull",
        "Full\nmoon", "Past\nfull", "Last\nquarter", "Fading\ncrescent"]
    static func name(from phase: Double) -> String {
        let nameCount = Double(names.count)
        let base = 0
        let offset = Int((phase + 0.5 / nameCount) * nameCount) % Int(nameCount)
        return names[base + offset]
    }
}
