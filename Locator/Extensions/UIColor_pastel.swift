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

    static let carGreyDark  = UIColor(red: 157.0/255.0, green: 157.0/255.0, blue:  157.0/255.0, alpha: 1.0)
    static let carGreyBlue  = UIColor(red: 123.0/255.0, green: 140.0/255.0, blue:  165.0/255.0, alpha: 1.0)
    static let carPink      = UIColor(red: 217.0/255.0, green: 201.0/255.0, blue:  202.0/255.0, alpha: 1.0)
    static let carStraw     = UIColor(red: 174.0/255.0, green: 153.0/255.0, blue:   88.0/255.0, alpha: 1.0)
    static let carBeetle    = UIColor(red: 187.0/255.0, green: 184.0/255.0, blue:  177.0/255.0, alpha: 1.0)
    static let carTrabant   = UIColor(red: 153.0/255.0, green: 163.0/255.0, blue:  172.0/255.0, alpha: 1.0)
    static let carSteel     = UIColor(red: 171.0/255.0, green: 190.0/255.0, blue:  205.0/255.0, alpha: 1.0)

    static let paleGrey     = UIColor(red: 223.0/255.0, green: 223.0/255.0, blue:  223.0/255.0, alpha: 1.0)
    static let paleRed      = UIColor(red: 223.0/255.0, green: 207.0/255.0, blue:  207.0/255.0, alpha: 1.0)
    static let paleGreen    = UIColor(red: 207.0/255.0, green: 223.0/255.0, blue:  207.0/255.0, alpha: 1.0)
    static let paleBlue     = UIColor(red: 207.0/255.0, green: 223.0/255.0, blue:  224.0/255.0, alpha: 1.0)
    static let paleUnRed    = UIColor(red: 207.0/255.0, green: 223.0/255.0, blue:  223.0/255.0, alpha: 1.0)
    static let paleUnGreen  = UIColor(red: 223.0/255.0, green: 207.0/255.0, blue:  223.0/255.0, alpha: 1.0)
    static let paleUnBlue   = UIColor(red: 223.0/255.0, green: 223.0/255.0, blue:  207.0/255.0, alpha: 1.0)
    static let clearBlue    = UIColor(red: 128.0/255.0, green: 183.0/255.0, blue:  228.0/255.0, alpha: 1.0)

    private static let pastels = [carGreyDark, carGreyBlue, carPink, carStraw,
                                  carBeetle, carTrabant, carSteel, paleGrey,
                                  paleRed, paleGreen, paleBlue, paleUnRed,
                                  paleUnGreen, paleUnBlue]

    public static func randomPastel() -> UIColor {

        var randomIndex: Int
        repeat {
            randomIndex = Int(arc4random_uniform(UInt32(pastels.count - 1)))
        } while randomIndex == previousIndex
        previousIndex = randomIndex
        return pastels[randomIndex]
    }
}
