//
//  CreditsViewController.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 23/01/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class CreditsViewController: UIViewController {

    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var returnButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func update(forecast: DarkSkyForecast, backgroundColor: UIColor, cornerRadius: CGFloat) {
        let foregroundColor = backgroundColor.darker

        screenTitle.text = "Credits"
        screenTitle.textColor = foregroundColor

        returnButton.setTitleColor(foregroundColor, for: .normal)
        view.backgroundColor = backgroundColor
        view.bottomCornerRadius = cornerRadius
    }
}
