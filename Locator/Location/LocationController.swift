//
//  LocationController.swift
//  Raincoat
//
//  Created by Vincent O'Sullivan on 11/10/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation
import CoreLocation

enum LocationStatus: Error {
    case authorityDenied
    case authorityRestricted
    case serviceNotEnabled
}

class LocationController: CLLocationManager {

    weak var locationDelegate: LocationControllerDelegate?
    var locationStatus: String = ""

    init(withDelegate delegate: LocationControllerDelegate) {
        self.locationDelegate = delegate
        super.init()
        requestAuthorization()
    }

    override func requestLocation() {
        // TASK: Review this code.
        print("LocationController: requesting location.  (enabled=\(CLLocationManager.locationServicesEnabled()))")
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                delegate = self
                desiredAccuracy = kCLLocationAccuracyHundredMeters
                super.requestLocation()
            case .denied, .notDetermined:
                locationDelegate?.locationController(self, didFailWithError: LocationStatus.authorityDenied)
            case .restricted:
                locationDelegate?.locationController(self, didFailWithError: LocationStatus.authorityRestricted)
            }
        } else {
            locationDelegate?.locationController(self, didFailWithError: LocationStatus.serviceNotEnabled)
        }
    }

    ///  Prompts the user to grant authozation for this application to
    ///  access the geographic location of the current device.
    ///
    private func requestAuthorization() {
        // Ask for Authorisation from the User.
        super.requestAlwaysAuthorization()

        // For use in foreground
        super.requestWhenInUseAuthorization()
    }
}

extension LocationController: CLLocationManagerDelegate {

    func locationManager(_ client: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("LocationController: didUpdate: \(locations)")
        let coords = locations[0].coordinate
        let location = Location(latitude: coords.latitude, longitude: coords.longitude)
        locationDelegate?.locationController(self, didUpdateLocation: location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationController: didFail: \(error.localizedDescription)")
        locationDelegate?.locationController(self, didFailWithError: error)
    }
}
