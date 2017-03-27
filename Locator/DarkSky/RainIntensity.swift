//
//  RainIntensity.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 26/01/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import Foundation

private enum Intensity: Double {
    case low = 1.0
    case medium = 8.0
    case high = 16.0
}

private enum Graph: Double {
    case low = 0.3333
    case medium = 0.6667
    case high = 1.0
}

struct RainIntensity {

    let data: [Double]

    private let rainLowRange = Intensity.low.rawValue
    private let rainMediumRange = Intensity.medium.rawValue - Intensity.low.rawValue
    private let rainHighRange = Intensity.high.rawValue - Intensity.medium.rawValue

    private let graphLowRange = 0.333
    private let graphMediumRange = 0.333
    private let graphHighRange = 0.333

    func factorised() -> [Double] {
        return data.map {
            switch $0 {
            case 0..<Intensity.low.rawValue:
                return $0 * graphLowRange / rainLowRange
            case Intensity.low.rawValue..<Intensity.medium.rawValue:
                return 0.3333 + ($0 - Intensity.low.rawValue) * graphMediumRange / rainMediumRange
            case Intensity.medium.rawValue..<Intensity.high.rawValue:
                return 0.6667 + ($0 - Intensity.medium.rawValue) * graphHighRange / rainHighRange
            default:
                return 1.0
            }
        }
    }
}
