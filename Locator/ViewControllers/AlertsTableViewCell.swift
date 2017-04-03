//
//  AlertsTableViewCell.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 03/04/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class AlertsTableViewCell: UITableViewCell {

    @IBOutlet weak var alertTitle: UILabel!
    @IBOutlet weak var timeIssued: UILabel!
    @IBOutlet weak var regions: UILabel!
    @IBOutlet weak var details: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
