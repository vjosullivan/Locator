//
//  Weather.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 12/01/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import UIKit

struct Weather {

    let symbol: String
    let color: UIColor
    let isDark: Bool

    init(symbol: String, color: UIColor, isDark: Bool) {
        self.symbol = symbol
        self.color = color
        self.isDark = isDark
    }

    static var clearDay: Weather {
        return Weather(symbol: "\u{F00D}", color: UIColor.clearDay, isDark: false)
    }
    static var clearNight: Weather {
        return Weather(symbol: "\u{F02E}", color: UIColor.clearNight, isDark: true)
    }
    static var rain: Weather {
        return Weather(symbol: "\u{F019}", color: UIColor.rainDay, isDark: false)
    }
    static var rainDay: Weather {
        return Weather(symbol: "\u{F019}", color: UIColor.rainDay, isDark: false)
    }
    static var rainNight: Weather {
        return Weather(symbol: "\u{F019}", color: UIColor.rainDay, isDark: false)
    }
    static var snow: Weather {
        return Weather(symbol: "\u{F01B}", color: UIColor.snow, isDark: false)
    }
    static var sleet: Weather {
        return Weather(symbol: "\u{F0B5}", color: UIColor.sleet, isDark: false)
    }
    static var wind: Weather {
        return Weather(symbol: "\u{F050}", color: UIColor.wind, isDark: false)
    }
    static var fog: Weather {
        return Weather(symbol: "\u{F014}", color: UIColor.fog, isDark: false)
    }
    static var cloudy: Weather {
        return Weather(symbol: "\u{F013}", color: UIColor.cloudy, isDark: false)
    }
    static var partlyCloudyDay: Weather {
        return Weather(symbol: "\u{F002}", color: UIColor.partlyCloudyDay, isDark: false)
    }
    static var partlyCloudyNight: Weather {
        return Weather(symbol: "\u{F086}", color: UIColor.partlyCloudyNight, isDark: true)
    }
    static var hail: Weather {
        return Weather(symbol: "\u{F015}", color: UIColor.hail, isDark: false)
    }
    static var thunderstorm: Weather {
        return Weather(symbol: "\u{F01E}", color: UIColor.thunderstorm, isDark: false)
    }
    static var tornado: Weather {
        return Weather(symbol: "\u{F056}", color: UIColor.tornado, isDark: false)
    }
    static var noWeatherDay: Weather {
        return Weather(symbol: "\u{F095}", color: UIColor.noWeatherDay, isDark: false)
    }
    static var windCalm: Weather {
        return Weather(symbol: "\u{F095}", color: UIColor.clear, isDark: false)
    }
    static var windDirection: Weather {
        return Weather(symbol: "\u{F0B1}", color: UIColor.clear, isDark: false)
    }
    static var barometer: Weather {
        return Weather(symbol: "\u{F079}", color: UIColor.clear, isDark: false)
    }
    static var thermometer: Weather {
        return Weather(symbol: "\u{F055}", color: UIColor.clear, isDark: false)
    }
    static var thermometerInside: Weather {
        return Weather(symbol: "\u{F054}", color: UIColor.clear, isDark: false)
    }
    static var thermometerOutside: Weather {
        return Weather(symbol: "\u{F053}", color: UIColor.clear, isDark: false)
    }

    // swiftlint:disable:next cyclomatic_complexity
    static func representedBy(darkSkyIcon: String) -> Weather {
        switch darkSkyIcon {
        case "clear-day": return Weather.clearDay
        case "clear-night": return Weather.clearNight
        case "rain": return Weather.rain
        case "rain-day": return Weather.rain
        case "snow": return Weather.snow
        case "sleet": return Weather.sleet
        case "wind": return Weather.wind
        case "fog": return Weather.fog
        case "cloudy": return Weather.cloudy
        case "partly-cloudy-day": return Weather.partlyCloudyDay
        case "partly-cloudy-night": return Weather.partlyCloudyNight
        default: return Weather.noWeatherDay
        }
    }
}
