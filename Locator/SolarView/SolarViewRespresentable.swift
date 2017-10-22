//
//  SolarViewRespresentable.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 21/10/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import Foundation

protocol SolarViewRepresentable {
    /// The local time of sunrise at the given forecast location.
    var sunriseTimeAtLocation: String { get }
    /// The local time of sunrise at the device running this app.
    var sunriseTimeAtDevice: String { get }
    /// The icon to be displayed, either for sunrise or for no sunrise.
    var sunriseIcon: String { get }
    /// The icon to be displayed, either for sunset or for no sunset.
    var sunsetIcon: String { get }
    /// The local time of sunset at the given forecast location.
    var sunsetTimeAtLocation: String { get }
    /// The local time of sunset at the device running this app.
    var sunsetTimeAtDevice: String { get }
    /// `true` if sunrise has already occurred today, otherwise `false`.
    var sunHasRisenToday: Bool { get }
    /// `true` if sunset has already occurred today, otherwise `false`.
    var sunHasSetToday: Bool { get }
    /// The amount of time left until the next sunrise or sunset today.
    var timeToSunRiseOrSet: String { get }
    /// The icon to be displayed to show the moon phase.
    var moonPhaseIcon: String { get }
    /// The text to be displayed to describle the moon phase.
    var moonPhaseText: String { get }
}
