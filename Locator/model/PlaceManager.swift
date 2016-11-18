//
//  PlaceManager.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 13/11/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation

class PlaceManager {

    private(set) var places: [Place]

    init() {
        places = PlaceManager.retrievePlaces()
    }

    func insert(_ place: Place) {
        places.insert(place, at: 0)
        PlaceManager.storeAllPlaces(places)
    }

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
    func storeDefaultPlace(_ index: Int) {
        let placeData = NSKeyedArchiver.archivedData(withRootObject: places[index])
        UserDefaults.standard.set(placeData, forKey: "place")
    }

    var placeCount: Int {
        return places.count
    }

    func place(at index: Int) -> Place {
        return places[index]
    }

    func removePlace(at index: Int) {
        places.remove(at: index)
        PlaceManager.storeAllPlaces(places)
    }

    func movePlace(from sourceRow: Int, to destinationRow: Int) {
        let place = places[sourceRow]
        places.remove(at: sourceRow)
        places.insert(place, at: destinationRow)
        PlaceManager.storeAllPlaces(places)
    }


    func clear() {
        UserDefaults.standard.removeObject(forKey: "places")
        places = [Place]()
    }

    func add(_ place: Place) {
        places = places.filter{ $0 != place }
        places.insert(place, at: 0)
        PlaceManager.storeAllPlaces(places)
    }

    /// Attempts to retrieve (from persistent storage) and return all the application's known `Place`s.
    ///
    /// - Returns: If found, returns the application's stored list of `Place`s, otherwise an empty `Place` list.
    ///
    func refresh() {
        guard let placesData = UserDefaults.standard.data(forKey: "places") else {
            places = [Place]()
            return
        }
        places = NSKeyedUnarchiver.unarchiveObject(with: placesData) as! [Place]
    }

    static func clearDefaultPlace() {
        UserDefaults.standard.removeObject(forKey: "place")
    }


    /// Persistently stores the application's list of known `Place`s
    ///
    /// - Parameter place: The application's list of known `Place`s.
    ///
    static func storeAllPlaces(_ places: [Place]) {
        let placesData = NSKeyedArchiver.archivedData(withRootObject: places)
        UserDefaults.standard.set(placesData, forKey: "places")
    }

    /// Attempts to retrieve (from persistent storage) and return all the application's known `Place`s.
    ///
    /// - Returns: If found, returns the application's stored list of `Place`s, otherwise an empty `Place` list.
    ///
    fileprivate static func retrievePlaces() -> [Place] {
        guard let placesData = UserDefaults.standard.data(forKey: "places") else {
            return [Place]()
        }
        return NSKeyedUnarchiver.unarchiveObject(with: placesData) as! [Place]
    }
}
