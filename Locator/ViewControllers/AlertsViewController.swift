//
//  AlertsViewController.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 25/03/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class AlertsViewController: UIViewController {

    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var returnButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func update(forecast: DarkSkyForecast, foregroundColor: UIColor?, backgroundColor: UIColor?) {

        let foreColor = foregroundColor ?? UIColor.white
        let backColor = backgroundColor ?? UIColor.darkGray

        screenTitle.text = "Alerts"
        screenTitle.textColor = foreColor

        returnButton.setTitleColor(foreColor, for: .normal)
        view.backgroundColor = backColor
    }
}
