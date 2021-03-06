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
    @IBOutlet weak var alertsTable: UITableView!
    @IBOutlet weak var summary: UILabel!
    @IBOutlet weak var returnButton: UIButton!

    private var alertsHandler = AlertsHandler()

    override func viewDidLoad() {
        super.viewDidLoad()

        alertsTable.dataSource = alertsHandler
        alertsTable.delegate = alertsHandler

        alertsTable.rowHeight = UITableViewAutomaticDimension
        alertsTable.estimatedRowHeight = 140
    }

    func update(forecast: DarkSkyForecast, backgroundColor: UIColor, cornerRadius: CGFloat) {
        let foregroundColor = backgroundColor.darker

        let plural = forecast.alerts?.count == 1 ? "" : "s"
        screenTitle.text = "\((forecast.alerts?.count ?? 0).asText.capitalized) Alert\(plural)"
        screenTitle.textColor = foregroundColor

        if forecast.alerts != nil {
            alertsTable.isHidden = false
            alertsHandler.update(using: forecast.alerts ?? [Alert](), backgroundColor: backgroundColor.darker(by: 0.75))
            alertsTable.reloadData()
        } else {
            alertsTable.isHidden = true
        }

        returnButton.setTitleColor(foregroundColor, for: .normal)
        view.backgroundColor = backgroundColor
        view.bottomCornerRadius = cornerRadius
    }
}
