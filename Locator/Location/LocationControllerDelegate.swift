//
//  LocationDelegate.swift
//  Raincoat
//
//  Created by Vincent O'Sullivan on 11/10/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationControllerDelegate {
    
    ///  Tells the delegate that new location information is available.
    ///
    ///  - parameter client:  The location API client that updated the location information.
    ///  - parameter location: The new location data.
    ///
    func location(controller: LocationController, didUpdateLocation location: Location)
    
    ///  Tells the delegate that the location manager failed to obtain a location.
    ///
    ///  - parameter client: The location API client that failed.
    ///  - parameter error:   The nature of the error encountered.
    ///
    func location(controller: LocationController, didFailWithError error: Error)

}
