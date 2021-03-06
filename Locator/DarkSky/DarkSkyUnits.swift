//
//  DarkSkyUnits.swift
//  Raincoat
//
//  Created by Vincent O'Sullivan on 25/09/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation

extension UnitSpeed {
    /// Custom measurement metric speed for railfall intensity.
    @nonobjc static let millimetersPerHour = UnitSpeed(symbol: "mm/h",
                                                       converter: UnitConverterLinear(coefficient: 0.0000002777778))
    /// Custom measurement imperial speed for railfall intensity.
    @nonobjc static let inchesPerHour      = UnitSpeed(symbol: "in/h",
                                                       converter: UnitConverterLinear(coefficient: 0.000007055552))
}

enum DarkSkyUnits {
    case auto
    case si
    case ca
    case uk2
    case us

    /// Returns a `UnitsFamily` value derived from the supplied `String`.
    ///
    /// - parameter string: A `DarkSkyUnits` identifier.
    ///
    /// - returns: A `DarkSkyUnits` 'family'.
    ///
    static func units(from string: String) -> DarkSkyUnits {
        switch string {
        case "si":
            return .si
        case "ca":
            return .ca
        case "uk2":
            return .uk2
        case "us":
            return .us
        default:
            return .auto
        }
    }

    var temperature: UnitTemperature {
        switch self {
        case .si, .ca, .uk2, .auto:
            return .celsius
        case .us:
            return .fahrenheit
        }
    }

    var angle: UnitAngle {
        return .degrees
    }

    var rainIntensity: UnitSpeed {
        switch self {
        case .si, .ca, .uk2, .auto:
            return .millimetersPerHour
        case .us:
            return .inchesPerHour
        }
    }

    var airPressure: UnitPressure {
        switch self {
        case .si, .auto:
            return .hectopascals
        case .uk2:
            return .millibars
        case .ca:
            return .kilopascals
        case .us:
            return .inchesOfMercury
        }
    }

    ///  The units used for measuring wind speed.
    var windSpeed: UnitSpeed {
        switch self {
        case .si, .auto:
            return .metersPerSecond
        case .ca:
            return .kilometersPerHour
        case .uk2:
            return .milesPerHour
        case .us:
            return .milesPerHour
        }
    }

    var distance: UnitLength {
        switch self {
        case .si, .ca, .auto:
            return .kilometers
        case .uk2, .us:
            return .miles
        }
    }

    var accumulation: UnitLength {
        switch self {
        case .si, .ca, .uk2, .auto:
            return .centimeters
        case .us:
            return .inches
        }
    }
}
