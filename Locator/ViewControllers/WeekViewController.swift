//
//  WeekViewController.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 23/01/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class WeekViewController: UIViewController {

    @IBOutlet weak var returnButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func update(forecast: DarkSkyForecast, foregroundColor: UIColor?, backgroundColor: UIColor?) {
        let foreColor = foregroundColor ?? UIColor.white
        let backColor = backgroundColor ?? UIColor.darkGray

        returnButton.setTitleColor(foreColor, for: .normal)
        view.backgroundColor = backColor
    }
}
