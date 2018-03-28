//
//  APIKeys.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 28/03/2018.
//  Copyright © 2018 Vincent O'Sullivan. All rights reserved.
//

import Foundation

func valueForAPIKey(_ key:String) -> String {
    // Credit to the original source for this technique at
    // http://blog.lazerwalker.com/blog/2014/05/14/handling-private-api-keys-in-open-source-ios-apps
    guard let filePath = Bundle.main.path(forResource: "APIKeys", ofType: "plist") else {
        fatalError("APIKeys:  Unable to determine plist file path.")
    }
    guard let plist = NSDictionary(contentsOfFile:filePath) as? [String: String] else {
        fatalError("APIKeys:  Unable to read plist using given file path.")
    }
    guard let value = plist[key] else {
        fatalError("APIKeys:  Unable to find value for key: \(key).")
    }
    return value
}
