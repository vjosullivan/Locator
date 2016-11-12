//
//  Place.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 12/11/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation
import MapKit

class Place: NSCoder {
    
    let name:    String
    let region:  String
    let placeID: String

    let latitude: Double
    let longitude: Double

    init(name: String, region: String, placeID: String, latitude: Double, longitude: Double) {
        self.name    = name
        self.region  = region
        self.placeID = placeID

        self.latitude  = latitude
        self.longitude = longitude
    }

    required init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        self.region = aDecoder.decodeObject(forKey: "region") as? String ?? ""
        self.placeID = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        self.latitude = aDecoder.decodeDouble(forKey: "latitude")
        self.longitude = aDecoder.decodeDouble(forKey: "longitude")

        super.init()
    }

    func encodeWithCoder(_ _aCoder: NSCoder) {
        _aCoder.encode(name, forKey: "name")
        _aCoder.encode(region, forKey: "region")
        _aCoder.encode(placeID, forKey: "placeID")
        _aCoder.encode(latitude, forKey: "latitude")
        _aCoder.encode(longitude, forKey: "longitude")
    }

    func encode(_aCoder: NSCoder) {
        _aCoder.encode(name, forKey: "name")
        _aCoder.encode(region, forKey: "region")
        _aCoder.encode(placeID, forKey: "placeID")
        _aCoder.encode(latitude, forKey: "latitude")
        _aCoder.encode(longitude, forKey: "longitude")
    }
}
