//
//  Int_extension.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 31/03/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import Foundation

extension Int {

    var asText: String {
        if 0 <= self && self <= 10 {
            return ["no", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten"][self]
        }
        return "\(self)"
    }
}
