//
//  AlertTableViewController.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 31/03/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class AlertsHandler: NSObject, UITableViewDataSource, UITableViewDelegate {

    private let reuseIdentifier = "AlertCell"
    private var alerts = [Alert]()

    func update(using alerts: [Alert]) {
        self.alerts = alerts
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alerts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        let cell = tableView
            .dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! AlertsTableViewCell
        // swiftlint:enable force_cast

        let alert = alerts[indexPath.row]
        cell.alertTitle.text = "\(alert.severity.capitalized) - \(alert.alertTitle)"
        switch alert.severity {
        case "advisory":
            cell.alertTitle.textColor = UIColor.green
        case "watch":
            cell.alertTitle.textColor = UIColor.amber
        case "warning":
            cell.alertTitle.textColor = UIColor.red
        default:
            cell.alertTitle.textColor = UIColor.white
        }
        cell.timeIssued.text = alert.formattedIssuedAtText(includeExpiry: false)
        cell.regions.text = alert.formattedRegionsText()
        cell.details.text = alert.details
        return cell
    }
}
