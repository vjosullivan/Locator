//
//  AlertCodable.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 07/04/2018.
//  Copyright © 2018 Vincent O'Sullivan. All rights reserved.
//

import Foundation

struct AlertCodable: Codable {
    let description: String?
    let expires: Date?
    let regions: [String]?
    let severity: String?
    let time: Date?
    let title: String?
    let uri: URL?
}
