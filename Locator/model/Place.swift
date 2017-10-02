//
//  Place.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 13/11/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation

class Place: NSObject, NSCoding {

    let name: String
    let region: String
    let placeID: String

    let latitude: Double
    let longitude: Double

    private(set) var coder: NSCoder? = nil

    init(name: String, region: String, placeID: String, latitude: Double, longitude: Double) {
        self.name    = name
        self.region  = region
        self.placeID = placeID

        self.latitude  = latitude
        self.longitude = longitude
        super.init()
    }

    // MARK: - NSCODER related methods.

    /// Required by `NSCoder`.
    required init?(coder aDecoder: NSCoder) {
        // swiftlint:disable force_cast
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.region = aDecoder.decodeObject(forKey: "region") as! String
        self.placeID = aDecoder.decodeObject(forKey: "placeID") as! String
        self.latitude = aDecoder.decodeDouble(forKey: "latitude")
        self.longitude = aDecoder.decodeDouble(forKey: "longitude")
        // swiftlint:enable force_cast
    }

    /// Required by `NSCoding`.
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(region, forKey: "region")
        aCoder.encode(placeID, forKey: "placeID")
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longitude, forKey: "longitude")

        coder = aCoder
    }
}
