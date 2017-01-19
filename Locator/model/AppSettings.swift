//
//  Settings.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 13/01/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import Foundation

struct AppSettings {

    /// Attempts to retrieve (from persistent storage) and return the application's default `Place`.
    ///
    /// - Returns: If found, returns the application's stored default `Place`, otherwise nil.
    ///
    static func retrieve(key: String) -> String? {
        guard let data = UserDefaults.standard.object(forKey: key) as? String else {
            return nil
        }
        return data
    }

    /// Attempts to retrieve (from persistent storage) and return the application's default `Place`.
    ///
    /// - Returns: If found, returns the application's stored default `Place`, otherwise nil.
    ///
    static func retrieve(key: String, defaultValue: String) -> String {
        guard let data = UserDefaults.standard.object(forKey: key) as? String else {
            return defaultValue
        }
        return data
    }

    /// Persistently stores the application's default `Place`, overwriting any perviously stored `Place`.
    ///
    /// - Parameter place: The application's (new) default place.
    static func store(key: String, value: String) {
        UserDefaults.standard.setValue(value, forKey: key)
    }
}
