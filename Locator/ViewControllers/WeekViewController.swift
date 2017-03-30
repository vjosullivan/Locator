//
//  WeekViewController.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 23/01/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class WeekViewController: UIViewController {

    @IBOutlet weak var weatherTable: UITableView!

    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var summary: UILabel!
    @IBOutlet weak var returnButton: UIButton!

    private var weatherHandler = WeatherHandler()

    override func viewDidLoad() {
        super.viewDidLoad()

        weatherTable.dataSource = weatherHandler
        weatherTable.delegate = weatherHandler
    }

    func update(forecast: DarkSkyForecast, foregroundColor: UIColor?, backgroundColor: UIColor?) {
        let foreColor = foregroundColor ?? UIColor.white
        let backColor = backgroundColor ?? UIColor.darkGray

        screenTitle.text = "This Week"
        screenTitle.textColor = foregroundColor

        weatherHandler.update(forecast: forecast, detailType: .week)
        weatherTable.reloadData()

        summary.textColor = foreColor
        summary.text = forecast.daily?.summary ?? ""

        returnButton.setTitleColor(foreColor, for: .normal)
        view.backgroundColor = backColor
    }
}
