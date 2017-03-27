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

    static let blueGray = UIColor(hexString: "7799BB")
    static let ashGray = UIColor(hexString: "B2BEB5")
    static let skyBlue = UIColor(hexString: "87CEEB")
    static let navy = UIColor(hexString: "000080")
    static let teal = UIColor(hexString: "008080")
    static let ocean = UIColor(hexString: "016064")
    static let slateGray = UIColor(hexString: "59788D")
    static let lightSlateGray = UIColor(hexString: "7E7D9C")
    static let agean = UIColor(hexString: "1E456E")
    static let sapphire = UIColor(hexString: "52B1C2")
    static let midnightBlue = UIColor(hexString: "5B7CB1")
    static let silver = UIColor(hexString: "C6C6D0")
    static let sienna = UIColor(hexString: "9A7B4F")
    static let darkOliveGreen = UIColor(hexString: "715B3D")

    static let hsbYellow = UIColor(hue: 52.5/360.0, saturation: 0.9, brightness: 1.0, alpha: 1.0)
    static let hsbBlue   = UIColor(hue: 195.0/360.0, saturation: 0.9, brightness: 1.0, alpha: 1.0)

    static let clearSky   = UIColor.clearDay.mixedWith(UIColor.clearNight)
    static let clearDay   = UIColor.skyBlue
    static let clearNight = UIColor.midnightBlue

    static let wind      = UIColor.windDay.mixedWith(UIColor.windNight)
    static let windDay   = UIColor.teal
    static let windNight = UIColor.ocean

    static let fog      = UIColor.fogDay.mixedWith(UIColor.fogNight)
    static let fogDay   = UIColor.ashGray
    static let fogNight = UIColor.agean

    static let partlyCloudy = UIColor.partlyCloudyDay.mixedWith(UIColor.partlyCloudyNight)
    static let partlyCloudyDay = UIColor.sapphire
    static let partlyCloudyNight = UIColor.ocean

    static let cloudy      = UIColor.blueGray.darker()
    static let cloudyDay   = UIColor.blueGray
    static let cloudyNight = UIColor.blueGray.darker().darker()

    static let rain      = UIColor.blueGray.lighter()
    static let rainDay   = UIColor.ashGray
    static let rainNight = UIColor.ocean

    static let hail      = UIColor.hailDay.mixedWith(UIColor.hailNight)
    static let hailDay   = UIColor.teal
    static let hailNight = UIColor.ocean

    static let thunderstorm      = UIColor.thunderstormDay.mixedWith(UIColor.thunderstormNight)
    static let thunderstormDay   = UIColor.agean
    static let thunderstormNight = UIColor.midnightBlue

    static let snow      = UIColor.snowDay.mixedWith(UIColor.snowNight)
    static let snowDay   = UIColor.silver
    static let snowNight = UIColor.lightSlateGray

    static let sleet      = UIColor.sleetDay.mixedWith(UIColor.sleetNight)
    static let sleetDay   = UIColor.silver
    static let sleetNight = UIColor.lightSlateGray

    static let tornado      = UIColor.tornadoDay.mixedWith(UIColor.tornadoNight)
    static let tornadoDay   = UIColor.teal
    static let tornadoNight = UIColor.ocean

    static let noWeather      = UIColor.noWeatherDay.mixedWith(UIColor.noWeatherNight)
    static let noWeatherDay   = UIColor.sienna
    static let noWeatherNight = UIColor.darkOliveGreen

    /// Initialises a `UIColor` generated from a six character hex string.
    /// The hex string may be preceded by an additional symbol `#`.
    /// If the hex string is invalid then the colour is initialsed to black.
    ///
    /// - Parameter hexString: A 6 or 7 character hex string of the form `AC0704` or `#123ABC`.
    ///
    convenience init(hexString: String) {
        var cString = hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString = cString.substring(from: 1)
        }

        if cString.characters.count != 6 || !UIColor.isHexString(cString) {
            self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            return
        }

        let rString = cString.substring(to: 2)
        let gString = cString.substring(from: 2).substring(to: 2)
        let bString = cString.substring(from: 4).substring(to: 2)

        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0

        let cgf255: CGFloat = 255.0
        self.init(red: CGFloat(r) / cgf255, green: CGFloat(g) / cgf255, blue: CGFloat(b) / cgf255, alpha: CGFloat(1))
    }

    private static func isHexString(_ string: String) -> Bool {
        let nonHexCharacters = CharacterSet(charactersIn: "0123456789ABCDEF").inverted

        if string.rangeOfCharacter(from: nonHexCharacters) != nil {
            return false
        }
        return true
    }

    private func mixedWith(_ color: UIColor) -> UIColor {
        let selfRGB = self.rgb()
        let otherRGB = color.rgb()
        return UIColor(
            red: (selfRGB.red + otherRGB.red) / 2.0,
            green: (selfRGB.green + otherRGB.green) / 2.0,
            blue: (selfRGB.blue + otherRGB.blue) / 2.0,
            alpha: 1.0)
    }

    func rgb() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var fRed: CGFloat = 0.0
        var fGreen: CGFloat = 0.0
        var fBlue: CGFloat = 0.0
        var fAlpha: CGFloat = 0.0
        let _ = self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha)
        return (red: fRed, green: fGreen, blue: fBlue, alpha: fAlpha)
    }

    func lighter() -> UIColor {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        let _ = self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return UIColor(hue: hue,
                       saturation: saturation,
                       brightness: brightness + (1.0 - brightness) * 0.2, alpha: alpha)
    }

    func darker() -> UIColor {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        let _ = self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return UIColor(hue: hue, saturation: saturation, brightness: brightness * 0.8333, alpha: alpha)
    }
}
