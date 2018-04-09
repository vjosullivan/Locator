//
//  ViewModel.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 20/10/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import Foundation

class SolarViewModel: SolarViewRepresentable {
    var sunriseTimeAtLocation: String
    var sunriseTimeAtDevice: String
    var sunriseIcon: String
    var sunHasRisenToday: Bool

    var sunsetTimeAtLocation: String
    var sunsetTimeAtDevice: String
    var sunsetIcon: String
    var sunHasSetToday: Bool

    var timeToSunRiseOrSet: String

    var moonPhaseIcon: String
    var moonPhaseText: String

    init(today: DataPointCodableViewModel) {

        sunriseTimeAtLocation = today.sunrise
        sunsetTimeAtLocation  = today.sunset
        if TimeZone.current.identifier != today.timeZone {
            sunriseTimeAtDevice = today.sunriseUsingDeviceTimezone
            sunsetTimeAtDevice  = today.sunsetUsingDeviceTimezone
        } else {
            sunriseTimeAtDevice = ""
            sunsetTimeAtDevice  = ""
        }

        sunriseIcon = today.sunriseIcon
        sunsetIcon  = today.sunsetIcon

        sunHasRisenToday = today.sunriseHasOccurred
        sunHasSetToday   = today.sunsetHasOccurred

        timeToSunRiseOrSet = today.timeToNextSunRiseOrSet

        moonPhaseIcon = today.moonIcon
        moonPhaseText = today.moonText
    }
}
