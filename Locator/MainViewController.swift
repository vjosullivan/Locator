//
//  MainViewController.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 12/11/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var uiPlace: UILabel!
    @IBOutlet weak var uiWeather: UILabel!

    var place: Place? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        if let place = retrievePlace() {
            uiPlace.text = "\(place.name)"
            uiWeather.text = "Weather\nfor\n\(place.name)"
        } else {
            uiPlace.text = "Current location"
            uiWeather.text = "Current weather"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func selectLocation() {
        performSegue(withIdentifier: "segueToLocationList", sender: nil)
    }

    @IBAction func unwindToMainVC(segue: UIStoryboardSegue) {
        print("XX")
        if segue.source is LocationListViewController {
            if let place = retrievePlace() {
                uiPlace.text = "\(place.name)"
                uiWeather.text = "Weather\nfor\n\(place.name)"
            } else {
                uiPlace.text = "Current location"
                uiWeather.text = "Current weather"
            }
        }
    }

    fileprivate func retrievePlace() -> Place? {
        guard let data = UserDefaults.standard.data(forKey: "place") else {
            return nil
        }
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? Place
    }

    fileprivate func storePlace(p: Place) {
        let data = NSKeyedArchiver.archivedData(withRootObject: p)
        UserDefaults.standard.set(data, forKey: "place")
    }
}
