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

    @IBOutlet weak var weatherTable: UITableView!

    @IBOutlet weak var buttonTopLeft: UIButton!
    @IBOutlet weak var buttonTopRight: UIButton!
    @IBOutlet weak var buttonBottomLeft: UIButton!
    @IBOutlet weak var buttonBottomRight: UIButton!

    @IBOutlet weak var summary: UILabel!

    private var weatherHandler = WeatherHandler()

    override func viewDidLoad() {
        super.viewDidLoad()

        buttonTopLeft.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi / 2.0)
        buttonTopRight.transform = CGAffineTransform.init(rotationAngle: -CGFloat.pi / 2.0)
        buttonBottomLeft.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi / 2.0)
        buttonBottomRight.transform = CGAffineTransform.init(rotationAngle: -CGFloat.pi / 2.0)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        weatherTable.dataSource = weatherHandler
        weatherTable.delegate = weatherHandler
    }

    func update(forecast: DarkSkyForecast,
                foregroundColor: UIColor?,
                backgroundColor: UIColor?,
                container: MainViewController) {

        mainVC = container

        let foreColor = foregroundColor ?? UIColor.white
        let backColor = backgroundColor ?? UIColor.darkGray

        titleBar.textColor = foreColor
        buttonTopLeft.setTitleColor(foreColor, for: .normal)
        buttonTopRight.setTitleColor(foreColor, for: .normal)
        buttonBottomLeft.setTitleColor(foreColor, for: .normal)
        buttonBottomRight.setTitleColor(foreColor, for: .normal)

        weatherHandler.update(forecast: forecast, detailType: .day )
        weatherTable.reloadData()
        
        summary.textColor = foreColor
        summary.text = forecast.hourly?.summary ?? ""

        view.backgroundColor = backColor
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
