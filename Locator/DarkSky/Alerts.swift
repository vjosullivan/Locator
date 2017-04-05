//
//  Alerts.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 31/03/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import Foundation

struct Alerts {

    let alerts: [Alert]?
}

extension Alerts {

    init?(from dictionary: [[String: AnyObject]]?) {
        guard let dictionary = dictionary, !dictionary.isEmpty else {
            return nil
        }

        alerts = Alerts.extractAlerts(from: dictionary)
    }

    private static func extractAlerts(from alertArray: [[String: AnyObject]]) -> [Alert]? {
        var extractedAlerts = [Alert]()
        for item in alertArray {
            if let issueTime = item["time"] as? TimeInterval,
                let alertTitle = item["title"] as? String,
                let alertDescription = item["description"] as? String,
                let alertRegions = item["regions"] as? [String],
                let alertSeverity = item["severity"] as? String,
                let alertURI = item["uri"] as? String {

                let expiryTime: Date?
                if let date = item["expires"] as? TimeInterval {
                    expiryTime = Date(timeIntervalSince1970: date)
                } else {
                    expiryTime = nil
                }
                print(alertURI)
                let alert = Alert(
                    issued: Date(timeIntervalSince1970: issueTime),
                    expires: expiryTime,
                    alertTitle: alertTitle,
                    details: alertDescription.realigned(),
                    regions: alertRegions,
                    severity: alertSeverity,
                    source: URL(fileURLWithPath: alertURI).absoluteString)
                extractedAlerts.append(alert)
            } else {
                print("Alert extraction failed.")
            }
        }
        return extractedAlerts
    }
}
