//
//  Location.swift
//  Raincoat
//
//  Created by Vincent O'Sullivan on 11/10/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

/// Represents a location on the earth's surface.
struct Location {
    let latitude: Double
    let longitude: Double

    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }

    init?(from dictionary: [String: Any]) {
        guard let latitude = dictionary["latitude"] as? Double,
            let longitude = dictionary["longitude"] as? Double else {
                return nil
        }
        self.init(latitude: latitude, longitude: longitude)
    }
}
