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

    static let paleGrey     = UIColor(red: 223.0/255.0, green: 223.0/255.0, blue:  223.0/255.0, alpha: 1.0)
    static let paleRed      = UIColor(red: 223.0/255.0, green: 207.0/255.0, blue:  207.0/255.0, alpha: 1.0)
    static let paleGreen    = UIColor(red: 207.0/255.0, green: 223.0/255.0, blue:  207.0/255.0, alpha: 1.0)
    static let paleBlue     = UIColor(red: 207.0/255.0, green: 223.0/255.0, blue:  224.0/255.0, alpha: 1.0)
    static let paleUnRed    = UIColor(red: 207.0/255.0, green: 223.0/255.0, blue:  223.0/255.0, alpha: 1.0)
    static let paleUnGreen  = UIColor(red: 223.0/255.0, green: 207.0/255.0, blue:  223.0/255.0, alpha: 1.0)
    static let paleUnBlue   = UIColor(red: 223.0/255.0, green: 223.0/255.0, blue:  207.0/255.0, alpha: 1.0)
    static let clearBlue    = UIColor(red: 128.0/255.0, green: 183.0/255.0, blue:  228.0/255.0, alpha: 1.0)

    private static let pastels = [paleGrey, paleRed, paleGreen, paleBlue, paleUnRed, paleUnGreen, paleUnBlue]

    public static func randomPastel() -> UIColor {

        var randomIndex: Int
        repeat {
            randomIndex = Int(arc4random_uniform(UInt32(pastels.count - 1)))
        } while randomIndex == previousIndex
        previousIndex = randomIndex
        return pastels[randomIndex]
    }
}
