//
//  UIColor_extension.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 25/12/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

extension UIColor {

    static let amber     = UIColor(red: 232.0/255.0, green: 97.0/255, blue: 0.0, alpha: 1.0)
    static let copper    = UIColor(hexString: "B87333")
    static let blueGray  = UIColor(hexString: "7799BB")
    static let ashGray   = UIColor(hexString: "B2BEB5")
    static let skyBlue   = UIColor(hexString: "87CEEB")
    static let cloudySky = UIColor(hexString: "BCCFD6")
    static let teal      = UIColor(hexString: "008080")
    static let ocean     = UIColor(hexString: "016064")
    static let agean     = UIColor(hexString: "1E456E")
    static let midnightBlue = UIColor(hexString: "5B7CB1")
    static let silver    = UIColor(hexString: "C6C6D0")
    static let sienna    = UIColor(hexString: "9A7B4F")

    static let clearDay   = UIColor.yellow
    static let clearNight = UIColor.midnightBlue
    static let wind       = UIColor.teal
    static let fog        = UIColor.ashGray
    static let partlyCloudyDay = UIColor.cloudySky
    static let partlyCloudyNight = UIColor.ocean
    static let cloudy     = UIColor.cloudySky.darker(by: 0.5)
    static let rain       = UIColor.blueGray.lighter
    static let rainDay    = UIColor.ashGray
    static let rainNight  = UIColor.ocean
    static let hail       = UIColor.teal
    static let thunderstorm      = UIColor.agean
    static let snow       = UIColor.silver
    static let sleet      = UIColor.silver
    static let tornado    = UIColor.teal
    static let noWeather  = UIColor.sienna

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
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)

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

    func rgb() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var fRed: CGFloat = 0.0
        var fGreen: CGFloat = 0.0
        var fBlue: CGFloat = 0.0
        var fAlpha: CGFloat = 0.0
        let _ = self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha)
        return (red: fRed, green: fGreen, blue: fBlue, alpha: fAlpha)
    }

    func hsb() -> (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var fHue: CGFloat = 0.0
        var fSaturation: CGFloat = 0.0
        var fBrightness: CGFloat = 0.0
        var fAlpha: CGFloat = 0.0
        let _ = self.getHue(&fHue, saturation: &fSaturation, brightness: &fBrightness, alpha: &fAlpha)
        return (hue: fHue, saturation: fSaturation, brightness: fBrightness, alpha: fAlpha)
    }

    var lighter: UIColor {
        return lighter(by: 0.75)
    }

    func lighter(by amount: CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0
        var b: CGFloat = 0, a: CGFloat = 0

        guard getHue(&h, saturation: &s, brightness: &b, alpha: &a)
            else {return self}

        return UIColor(hue: h,
                       saturation: s * (1 - amount), //s + (1 - s) * amount,
                       brightness: b + (1 - b) * amount,
                       alpha: a)
    }

    var darker: UIColor {
        return darker(by: 0.4)
    }

    func darker(by amount: CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0
        var b: CGFloat = 0, a: CGFloat = 0

        guard getHue(&h, saturation: &s, brightness: &b, alpha: &a)
            else {return self}

        return UIColor(hue: h,
                       saturation: s + (1 - s) * amount, // s * (1 - amount),
                       brightness: b * (1 - amount),
                       alpha: a)
    }
}

extension UIColor {
    func rgbComponents() -> String {
        let rgb = self.rgb()
        return "Red: \(Int(rgb.red * 255.0)).  Green: \(Int(rgb.green * 255.0)).  Blue: \(Int(rgb.blue * 255.0))."
    }
    func hsbComponents() -> String {
        let hsb = self.hsb()
        return "Hue: \(Int(hsb.hue * 255.0)).  Saturation: \(Int(hsb.saturation * 255.0)).  brightness: \(Int(hsb.brightness * 255.0))."
    }
}
