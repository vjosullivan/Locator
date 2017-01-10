//
//  SettingsViewController.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 02/01/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var usButton: UIButton!
    @IBOutlet weak var ukButton: UIButton!
    @IBOutlet weak var caButton: UIButton!
    @IBOutlet weak var siButton: UIButton!
    
    @IBOutlet weak var usUnits: UILabel!
    @IBOutlet weak var ukUnits: UILabel!
    @IBOutlet weak var caUnits: UILabel!
    @IBOutlet weak var siUnits: UILabel!
    
    @IBOutlet weak var returnButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Settings viewDidLoad")
    }
    
    func update(forecast: DarkSkyForecast, foregroundColor: UIColor?, backgroundColor: UIColor?) {
        
        let foreColor = foregroundColor ?? UIColor.white
        let backColor = backgroundColor ?? UIColor.darkGray
        
        view.backgroundColor = backColor
    }
    
    @IBAction func switchUnits(_ sender: UIButton) {
        switch sender {
        case usButton:
            usUnits.font
        case ukButton:
            break
        case caButton:
            break
        case siButton:
            break
        default:
            break
        }
    }
}
