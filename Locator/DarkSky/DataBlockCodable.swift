//
//  DataGroupCodable.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 07/04/2018.
//  Copyright © 2018 Vincent O'Sullivan. All rights reserved.
//

import Foundation

struct DataBlockCodable: Codable {
    let icon: String?
    let summary: String?
    let data: [DataPointCodable]
}
