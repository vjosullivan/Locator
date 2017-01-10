//
//  DetailedForecast.swift
//  Raincoat
//
//  Created by Vincent O'Sullivan on 01/10/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation

/// A detailed forecast is basically a collection of `DataPoint`s, with a covering summary and icon.
struct DetailedForecast {
    let summary: String?
    let icon: String?

    let dataPoints: [DataPoint]?
}

extension DetailedForecast {

    init?(dictionary: [String: AnyObject]?, units: DarkSkyUnits) {
        guard let dictionary = dictionary else {
            return nil
        }
        summary = dictionary["summary"] as? String
        icon    = dictionary["icon"] as? String

        dataPoints = [DataPoint]()
        if let dataList = dictionary["data"] as? [[String: AnyObject]] {
            for dataPoint in dataList {
                if let detail = DataPoint(dictionary: dataPoint, units: units) {
                    dataPoints?.append(detail)
                }
            }
        }
        if summary == nil && icon == nil && (dataPoints?.isEmpty ?? true) {
            return nil
        }
    }
}
