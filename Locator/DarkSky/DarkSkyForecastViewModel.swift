//
//  DarkSkyCodableViewModel.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 08/04/2018.
//  Copyright © 2018 Vincent O'Sullivan. All rights reserved.
//

import Foundation

struct DarkSkyForecastViewModel {

    private let darkSkyForecast: DarkSkyForecastCodable

    public var current: DataPointCodableViewModel {
        return DataPointCodableViewModel(dataPoint: darkSkyForecast.currently, timeZone: darkSkyForecast.timezone, units: darkSkyForecast.flags?.units ?? "")
    }

    public var today: DataPointCodableViewModel {
        return DataPointCodableViewModel(dataPoint: darkSkyForecast.daily?.data[0], timeZone: darkSkyForecast.timezone, units: darkSkyForecast.flags?.units ?? "")
    }

    public var units: String {
        return darkSkyForecast.flags?.units ?? ""
    }

    init(darkSkyForecastModel: DarkSkyForecastCodable) {
        darkSkyForecast = darkSkyForecastModel
    }
}
