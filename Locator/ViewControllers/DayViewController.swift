//
//  DayViewController.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 23/01/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class DayViewController: UIViewController {

    var mainVC: MainViewController?

    @IBOutlet weak var titleBar: UILabel!

    @IBOutlet weak var buttonTopLeft: UIButton!
    @IBOutlet weak var labelTopLeft: UILabel!
    @IBOutlet weak var buttonTopRight: UIButton!
    @IBOutlet weak var labelTopRight: UILabel!
    @IBOutlet weak var buttonBottomLeft: UIButton!
    @IBOutlet weak var labelBottomLeft: UILabel!
    @IBOutlet weak var buttonBottomRight: UIButton!
    @IBOutlet weak var labelBottomRight: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func update(forecast: DarkSkyForecast,
                foregroundColor: UIColor?,
                backgroundColor: UIColor?,
                container: MainViewController) {

        mainVC = container

        let foreColor = foregroundColor ?? UIColor.white
        let backColor = backgroundColor ?? UIColor.darkGray

        titleBar.textColor = foreColor
        view.backgroundColor = backColor

        buttonTopLeft.layer.borderColor = UIColor.lightGray.cgColor
        buttonTopRight.layer.borderColor = UIColor.lightGray.cgColor
        buttonBottomLeft.layer.borderColor = UIColor.lightGray.cgColor
        buttonBottomRight.layer.borderColor = UIColor.lightGray.cgColor
    }

    // MARK: - Actions

    /// Calls an automated action the "flips" between two displayed screens.  The particular screen revealed
    /// is dependent upon the button calling the action.
    ///
    /// - Parameter sender: The button requesting the action.
    ///
    @IBAction func flip(_ sender: UIButton) {
        guard let mainVC = mainVC else {
            return
        }
        switch true {
        case sender == buttonTopLeft: // 24 hour forecast
            mainVC.flip(mainVC.dayPanel, rearView: mainVC.hourPanel)
        case sender == buttonTopRight: // 7 day forecast
            mainVC.flip(mainVC.dayPanel, rearView: mainVC.weekPanel)
        case sender == buttonBottomLeft: // Weather alerts
            mainVC.flip(mainVC.dayPanel, rearView: mainVC.alertsPanel)
        case sender == buttonBottomRight: // Credits
            mainVC.flip(mainVC.dayPanel, rearView: mainVC.creditsPanel)
        default:
            break
        }
    }
}
