//
//  Time.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 21/10/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import Foundation

protocol Clock {
    var currentDateTime: Date { get }
}
