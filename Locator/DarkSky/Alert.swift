//
//  Alert.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 30/03/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import Foundation


/// Represents a weather alert as presented by the DarkSky API.
///
struct Alert {

    /// The UNIX time at which the alert was issued.
    let issued: Date

    /// The UNIX time at which the alert will expire.
    let expires: Date?

    /// A brief description of the alert.
    let title: String

    /// A detailed description of the alert.
    let description: String

    /// An array of strings representing the names of the regions covered by this weather alert.
    let regions: [String]

    /// The severity of the weather alert. 
    /// Take one of the following values: `low` (advisory), `medium` (watch) and `high` (warning).
    let severity: Severity

    /// An HTTP(S) URI that one may refer to for detailed information about the alert.
    let source: String
}

enum Severity {
    case high    // US weather "warning"
    case medium  // US weather "watch"
    case low     // US weather "advisory"
}
