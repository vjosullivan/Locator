//
//  DarkSkyForecastCodable.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 07/04/2018.
//  Copyright © 2018 Vincent O'Sullivan. All rights reserved.
//

import Foundation

struct DarkSkyForecastCodable: Codable {
    let latitude:  Double
    let longitude: Double
    let timezone:  String

    let currently: DataPointCodable?
    
    let minutely:  DataBlockCodable?
    let hourly:    DataBlockCodable?
    let daily:     DataBlockCodable?

    let alerts:    [AlertCodable]?
    let flags:     FlagsCodable?
}

extension DarkSkyForecastCodable: CustomStringConvertible {
    var description: String {
        return String("\(latitude), \(longitude) (\(timezone))")
    }
}
