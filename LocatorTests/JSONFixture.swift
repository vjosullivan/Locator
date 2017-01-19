//
//  JSONFixture.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 19/01/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import Foundation

/// Handles the conversion of local (test) JSON files (fixtures) into dictionaries.
/// Errors in finding or interpreting the data are "reported" as print statements.
class JSONFixture {

    public private(set) var dictionary: [String: Any]? = nil

    init?(from fixture: String) {
        if let jsonString = readFixture(fixture) {
            dictionary = dictionary(from: jsonString)
        }
    }

    private func readFixture(_ fixture: String) -> String? {
        guard let path = Bundle(for: type(of: self)).path(forResource: fixture, ofType: "json") else {
            print("JSON Fixture: File '\(fixture).json' not found.")
            return nil
        }
        do {
            return try String.init(contentsOfFile: path, encoding: .utf8)
        } catch {
            print("JSON Fixture: (file read) \(error.localizedDescription)")
            return nil
        }
    }

    private func dictionary(from string: String) -> [String: Any]? {
        guard let data = string.data(using: .utf8) else {
            print("JSON Fixture: Unable to extract data from contents.")
            return nil
        }
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print("JSON Fixture: (data conversion) \(error.localizedDescription)")
            return nil
        }
    }
}
