//
//  AppDelegate.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 08/11/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private static let googleAPIKey: String? = valueForAPIKey("GOOGLE_PLACES_API_KEY")
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if let key = AppDelegate.googleAPIKey {
            GMSPlacesClient.provideAPIKey(key)
        } else {
            fatalError("Google places API key required.")
        }
        return true
    }
}
