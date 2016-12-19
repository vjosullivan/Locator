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

    private var locationController: LocationController?

    // MARK: - UIViewController functions.

    override func viewDidLoad() {
        super.viewDidLoad()
        update()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - IBActions.

    @IBAction func selectLocation() {
        performSegue(withIdentifier: "segueToLocationList", sender: nil)
    }

    /// Called when unwinding a segue back to this view.
    ///
    /// - Parameter segue: The segue being unwound.
    ///
    @IBAction func unwindToMainVC(segue: UIStoryboardSegue) {
        print("Unwinding from location controller")
        if segue.source is LocationListViewController {
            update()
        }
    }

    // MARK: - Local functions.

    private func update() {
        print("Update.")
        if let place = PlaceManager.retrieveDefaultPlace() {
            print("Update retreived place '\(place.name)'.")
            updateWeather(for: place)
        } else {
            print("Update.  Fetch location.")
            locationController = LocationController(withDelegate: self)
            locationController?.requestLocation()
        }
    }

    fileprivate func updateWeather(for place: Place) {
        print("Update weather for \(place.latitude), \(place.longitude).")
        let darkSky = DarkSkyClient(location: Location(latitude: place.latitude, longitude: place.longitude))
        darkSky.fetchForecast{ darkSkyForecast in
            print("SSS")
            DispatchQueue.main.async {
                self.updateDisplay(with: darkSkyForecast, for: place)
            }
        }
    }

    private func updateDisplay(with forecast: DarkSkyForecast, for place: Place) {
        print("Update display.")
        // TODO: Incorporate location info into forecast.
//        if let place = PlaceManager.retrieveDefaultPlace() {
        uiPlace.text = place.region != "" ? place.region : place.name
        if let summary = forecast.current?.summary {
            uiWeather.text = "\(summary)."
            if let temperature = forecast.current?.temperature {
                uiWeather.text = uiWeather.text! + "\n\(temperature)"
            }
        } else {
            uiWeather.text = "No idea."
        }
//        } else {
//            uiPlace.text = "Current location"
//            uiWeather.text = "Currently its\n\(forecast.current?.summary)"
//        }
    }
}

extension MainViewController: LocationControllerDelegate {

    func location(controller: LocationController, didUpdateLocation location: Location) {
        print("Location found.")
        let place = Place(name: "Current location", region: "", placeID: "", latitude: location.latitude, longitude: location.longitude)
        print("VOS XXX")
        updateWeather(for: place)
    }

    func location(controller: LocationController, didFailWithError error: Error) {
        print("Location not found.")
        let alertController = UIAlertController(title: "Current Weather", message: "No weather forecast available at the moment.\n\n\(error)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

