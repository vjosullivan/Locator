//
//  UIColor_extension.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 25/12/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

extension UIColor {
    
    static let amber  = UIColor(red: 1.0, green: 88.0/255, blue: 0.0, alpha: 1.0)
    static let bronze = UIColor(red: 205.0/255.0, green: 127.0/255.0, blue: 50.0/255.0, alpha: 1.0)
    static let naturalYellow = UIColor(red: 255.0/255.0, green: 211.0/255.0, blue: 0.0, alpha: 1.0)
    
    static let hsbYellow = UIColor(hue: 52.5/360.0, saturation: 0.9, brightness: 1.0, alpha: 1.0)
    static let hsbBlue   = UIColor(hue: 195.0/360.0, saturation: 0.9, brightness: 1.0, alpha: 1.0)

    static let clearSky   = UIColor.clearDay.mixedWith(UIColor.clearNight)
    static let clearDay   = UIColor.hsbYellow //(red: 135.0/255.0, green: 206.0/255.0, blue: 235.0/255.0, alpha: 1.0)
    static let clearNight = UIColor(red:  25.0/255.0, green:  25.0/255.0, blue: 112.0/255.0, alpha: 1.0)
    
    static let wind      = UIColor.windDay.mixedWith(UIColor.windNight)
    static let windDay   = UIColor(red: 116.0/255.0, green: 195.0/255.0, blue: 221.0/255.0, alpha: 1.0)
    static let windNight = UIColor(red: 121.0/255.0, green: 135.0/255.0, blue: 153.0/255.0, alpha: 1.0)
    
    static let fog      = UIColor.fogDay.mixedWith(UIColor.fogNight)
    static let fogDay   = UIColor(red: 103.0/255.0, green: 184.0/255.0, blue: 207.0/255.0, alpha: 1.0)
    static let fogNight = UIColor(red:  85.0/255.0, green:  94.0/255.0, blue: 102.0/255.0, alpha: 1.0)
    
    static let partlyCloudy      = UIColor.partlyCloudyDay.mixedWith(UIColor.partlyCloudyNight)
    static let partlyCloudyDay   = UIColor(red:  90.0/255.0, green: 173.0/255.0, blue: 193.0/255.0, alpha: 1.0)
    static let partlyCloudyNight = UIColor(red: 121.0/255.0, green: 135.0/255.0, blue: 153.0/255.0, alpha: 1.0)
    
    static let cloudy      = UIColor.cloudyDay.mixedWith(UIColor.cloudyNight)
    static let cloudyDay   = UIColor(red:  77.0/255.0, green: 162.0/255.0, blue: 179.0/255.0, alpha: 1.0)
    static let cloudyNight = UIColor(red:  85.0/255.0, green:  94.0/255.0, blue: 102.0/255.0, alpha: 1.0)
    
    static let rain      = UIColor.rainDay.mixedWith(UIColor.rainNight)
    static let rainDay   = UIColor(red:  64.0/255.0, green: 151.0/255.0, blue: 165.0/255.0, alpha: 1.0)
    static let rainNight = UIColor(red: 121.0/255.0, green: 135.0/255.0, blue: 153.0/255.0, alpha: 1.0)
    
    static let hail      = UIColor.hailDay.mixedWith(UIColor.hailNight)
    static let hailDay   = UIColor(red: 51.0/255.0, green: 140.0/255.0, blue: 157.0/255.0, alpha: 1.0)
    static let hailNight = UIColor(red: 20.0/255.0, green: 35.0/255.0, blue: 51.0/255.0, alpha: 1.0)
    
    static let thunderstorm      = UIColor.thunderstormDay.mixedWith(UIColor.thunderstormNight)
    static let thunderstormDay   = UIColor(red:  38.0/255.0, green: 129.0/255.0, blue: 137.0/255.0, alpha: 1.0)
    static let thunderstormNight = UIColor(red:  20.0/255.0, green: 35.0/255.0, blue: 51.0/255.0, alpha: 1.0)
    
    static let snow      = UIColor.snowDay.mixedWith(UIColor.snowNight)
    static let snowDay   = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    static let snowNight = UIColor(red:  20.0/255.0, green:  35.0/255.0, blue:  51.0/255.0, alpha: 1.0)
    
    static let sleet      = UIColor.sleetDay.mixedWith(UIColor.sleetNight)
    static let sleetDay   = UIColor.rainDay.mixedWith(UIColor.snowDay)
    static let sleetNight = UIColor.rainNight.mixedWith(UIColor.snowNight)
    
    static let tornado      = UIColor.tornadoDay.mixedWith(UIColor.tornadoNight)
    static let tornadoDay   = UIColor(red: 253.0/255.0, green: 1.0, blue: 203.0/255.0, alpha: 1.0)
    static let tornadoNight = UIColor(red: 20.0/255.0, green: 35.0/255.0, blue: 51.0/255.0, alpha: 1.0)
    
    static let noWeather      = UIColor.noWeatherDay.mixedWith(UIColor.noWeatherNight)
    static let noWeatherDay   = UIColor.red.darker().darker()
    static let noWeatherNight = UIColor.blue.darker().darker()
 
    private func mixedWith(_ color: UIColor) -> UIColor {
        let selfRGB = self.rgb()
        let otherRGB = color.rgb()
        return UIColor(
            red: (selfRGB.red + otherRGB.red) / 2.0,
            green: (selfRGB.green + otherRGB.green) / 2.0,
            blue: (selfRGB.blue + otherRGB.blue) / 2.0,
            alpha: 1.0)
    }
    
    private func rgb() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var fRed: CGFloat = 0
        var fGreen: CGFloat = 0
        var fBlue: CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            return (red: fRed, green: fGreen, blue: fBlue, alpha: fAlpha)
        } else {
            // Could not extract RGBA components:
            return (red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        }
    }
    
    func lighter() -> UIColor {
        var hue:        CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha:      CGFloat = 0.0
        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness + (1.0 - brightness) * 0.1667, alpha: alpha)
        } else {
            return UIColor.white
        }
    }
    
    func darker() -> UIColor {
        var hue:        CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha:      CGFloat = 0.0
        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness * 0.8333, alpha: alpha)
        } else {
            return UIColor.white
        }
    }
}
