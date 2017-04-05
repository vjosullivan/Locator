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
    let alertTitle: String

    /// A detailed description of the alert.
    let details: String

    /// An array of strings representing the names of the regions covered by this weather alert.
    let regions: [String]

    /// The severity of the weather alert. 
    let severity: String

    /// An HTTP(S) URI that one may refer to for detailed information about the alert.
    let source: String

    public func formattedIssuedAtText(includeExpiry: Bool = true) -> String {
        let form1 = DateFormatter()
        form1.dateFormat = "eee"
        let form2 = DateFormatter()
        form2.dateStyle = .medium
        form2.timeStyle = .short
        var text = "Issued: \(form1.string(from: issued)), \(form2.string(from: issued))."
        if includeExpiry, let expires = expires {
            text += "  Expires: \(form1.string(from: expires)), \(form2.string(from: expires))."
        }
        return text
    }

    public func formattedRegionsText() -> String {
        guard !regions.isEmpty else {
            return "-"
        }
        var text = "For: "
        for i in 0..<regions.count {
            let suffix: String
            switch regions.count - i {
            case 1:
                suffix = "."
            case 2:
                suffix = " and "
            default:
                suffix = ", "
            }
            text += regions[i] + suffix
        }
        return text
    }
}
