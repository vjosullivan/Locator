//
//  PastelColor.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 06/04/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import UIKit

extension UIColor {

    private static var previousIndex = -1

    static let pastelGreen  = UIColor(red:  83.0/255.0, green: 151.0/255.0, blue:  112.0/255.0, alpha: 1.0)
    static let dimGray      = UIColor(red:  75.0/255.0, green: 125.0/255.0, blue:  116.0/255.0, alpha: 1.0)
    static let pastelBlue   = UIColor(red: 141.0/255.0, green: 194.0/255.0, blue:  188.0/255.0, alpha: 1.0)
    static let wheat        = UIColor(red: 237.0/255.0, green: 214.0/255.0, blue:  180.0/255.0, alpha: 1.0)
    static let indianRed    = UIColor(red: 190.0/255.0, green: 116.0/255.0, blue:  103.0/255.0, alpha: 1.0)
    static let sandyBrown   = UIColor(red: 226.0/255.0, green: 174.0/255.0, blue:   99.0/255.0, alpha: 1.0)
    static let pastelYellow = UIColor(red: 238.0/255.0, green: 221.0/255.0, blue:  152.0/255.0, alpha: 1.0)
    static let clearBlue      = UIColor(red: 127.0/255.0, green: 183.0/255.0, blue:  229.0/255.0, alpha: 1.0)

    private static let pastels = [pastelGreen, dimGray, pastelBlue, wheat, indianRed, sandyBrown, pastelYellow, clearBlue]

    public static func randomPastel() -> UIColor {

        var randomIndex: Int
        repeat {
            randomIndex = Int(arc4random_uniform(UInt32(pastels.count - 1)))
        } while randomIndex == previousIndex
        previousIndex = randomIndex
        return pastels[randomIndex]
    }
}
