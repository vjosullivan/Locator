//
//  Place.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 13/11/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation

class Place: NSCoder {

    let name:    String
    let region:  String
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
    }

    // MARK: - NSCODER related methods.

    required init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.region = aDecoder.decodeObject(forKey: "region") as! String
        self.placeID = aDecoder.decodeObject(forKey: "placeID") as! String
        self.latitude = aDecoder.decodeDouble(forKey: "latitude")
        self.longitude = aDecoder.decodeDouble(forKey: "longitude")
    }

    func encodeWithCoder(_ _aCoder: NSCoder) {
        _aCoder.encode(name, forKey: "name")
        _aCoder.encode(region, forKey: "region")
        _aCoder.encode(placeID, forKey: "placeID")
        _aCoder.encode(latitude, forKey: "latitude")
        _aCoder.encode(longitude, forKey: "longitude")

        coder = _aCoder
    }
}

// MARK: - Persistent storage functions.
extension Place {

    /// Attempts to retrieve (from persistent storage) and return the application's default `Place`.
    ///
    /// - Returns: If found, returns the application's stored default `Place`, otherwise nil.
    ///
    static func retrieveDefaultPlace() -> Place? {
        guard let data = UserDefaults.standard.data(forKey: "place") else {
            return nil
        }
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? Place
    }

    /// Persistently stores the application's default `Place`, overwriting any perviously stored `Place`.
    ///
    /// - Parameter place: The application's (new) default place.
    static func storeDefaultPlace(_ place: Place) {
        let placeData = NSKeyedArchiver.archivedData(withRootObject: place)
        UserDefaults.standard.set(placeData, forKey: "place")
    }

    static func clearDefaultPlace() {
        UserDefaults.standard.removeObject(forKey: "place")
    }

    /// Attempts to retrieve (from persistent storage) and return all the application's known `Place`s.
    ///
    /// - Returns: If found, returns the application's stored list of `Place`s, otherwise an empty `Place` list.
    ///
    static func retrieveAllPlaces() -> [Place] {
        guard let placesData = UserDefaults.standard.data(forKey: "places") else {
            return [Place]()
        }
        return NSKeyedUnarchiver.unarchiveObject(with: placesData) as! [Place]
    }

    /// Persistently stores the application's list of known `Place`s
    ///
    /// - Parameter place: The application's list of known `Place`s.
    ///
    static func storeAllPlaces(_ places: [Place]) {
        let placesData = NSKeyedArchiver.archivedData(withRootObject: places)
        UserDefaults.standard.set(placesData, forKey: "places")
    }

    static func clearAllPlaces() {
        UserDefaults.standard.removeObject(forKey: "places")
    }

    static func storeAdditionalPlace(_ place: Place) {
        var places = Place.retrieveAllPlaces()
        places.insert(place, at: 0)
        Place.storeAllPlaces(places)

    }
}
