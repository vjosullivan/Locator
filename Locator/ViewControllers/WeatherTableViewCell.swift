//
//  WeatherTableViewCell.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 26/03/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var icon: UILabel!
    @IBOutlet weak var maxTemperature: UILabel!
    @IBOutlet weak var rain: RaindropLabel!
    @IBOutlet weak var windBearing: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    //@IBOutlet weak var summary: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
