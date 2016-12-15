//
//  LocationController.swift
//  Raincoat
//
//  Created by Vincent O'Sullivan on 11/10/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation
import CoreLocation

class LocationController: CLLocationManager {
    
    let locationDelegate: LocationControllerDelegate
    var locationStatus: String = ""
    
    init(withDelegate delegate: LocationControllerDelegate) {
        self.locationDelegate = delegate
        super.init()
        print("VOS07")
        requestAuthorization()
    }
    
    override func requestLocation() {
        // TASK: Review this code.
        print("VOS01")
        if CLLocationManager.locationServicesEnabled() {
            print("VOS02")
            delegate = self
            desiredAccuracy = kCLLocationAccuracyHundredMeters
            super.requestLocation()
            print("VOS02a")
        }
        print("VOS03 - requestLocation - \(Date())")
    }
        
    ///  Prompts the user to grant authozation for this application to
    ///  access the geographic location of the current device.
    ///
    private func requestAuthorization() {
        print("VOS06: Requesting authorization.")
        // Ask for Authorisation from the User.
        super.requestAlwaysAuthorization()

        // For use in foreground
        super.requestWhenInUseAuthorization()
        print("VOS06a: Requested authorization.")
    }
}

extension LocationController: CLLocationManagerDelegate {
    
    func locationManager(_ client: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("VOS04 - didUpdateLocations - \(NSDate())")
        let coords = locations[0].coordinate
        let location = Location(latitude: coords.latitude, longitude: coords.longitude)
        locationDelegate.location(controller: self, didUpdateLocation: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("VOS05")
        locationDelegate.location(controller: self, didFailWithError: error)
    }
}
