//
//  MockClock.swift
//  LocatorTests
//
//  Created by Vincent O'Sullivan on 21/10/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import Foundation
@testable import Locator

struct MockClock: Clock {

    let timeIntervalSince1970: TimeInterval

    var currentDateTime: Date {
        return Date(timeIntervalSince1970: timeIntervalSince1970)
    }
}
