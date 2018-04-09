//
//  FlagsCodable.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 08/04/2018.
//  Copyright © 2018 Vincent O'Sullivan. All rights reserved.
//

import Foundation

struct FlagsCodable: Codable {

    let darkSkyUnavailable: String?
    let sources: [String]
    let units: String
    let isdStations: [String]?

    enum CodingKeys: String, CodingKey
    {
        case darkSkyUnavailable = "darksky-unavailable"
        case sources
        case units
        case isdStations = "isd-stations"
    }
}
