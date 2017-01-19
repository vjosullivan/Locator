//
//  MainViewController.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 12/11/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    let radianConvertion = CGFloat.pi / 180.0

    // These views have coloured backgrounds in the storyboard which are cleared when run.
    @IBOutlet var backgroundColoredViews: [UIView]!

    @IBOutlet weak var uiPlace: UILabel!
    @IBOutlet weak var minuteSummary: UILabel!
    @IBOutlet weak var hourSummary: UILabel!

    @IBOutlet weak var currentWeatherSymbol: UILabel!

    @IBOutlet weak var buttonBTR: UIButton!
    @IBOutlet weak var buttonBTL: UIButton!
    @IBOutlet weak var buttonBBR: UIButton!
    @IBOutlet weak var buttonBBL: UIButton!

    @IBOutlet weak var frontPanel: UIView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var settingsPanel: UIView!
    @IBOutlet weak var solarPanel: UIView!
    @IBOutlet weak var detailsPanel: UIView!

    private var frontVC: FrontViewController?
    private var settingsVC: SettingsViewController?
    private var solarVC: SolarViewController?
    private var detailsVC: DetailsViewController?

    private var locationController: LocationController?

    @IBOutlet weak var viewB: UIView!

    // MARK: - UIViewController functions.

    override func viewDidLoad() {
        super.viewDidLoad()

        buttonBTR.layer.borderColor = UIColor.lightGray.cgColor
        buttonBBR.layer.borderColor = UIColor.lightGray.cgColor
        buttonBTL.layer.borderColor = UIColor.lightGray.cgColor
        buttonBBL.layer.borderColor = UIColor.lightGray.cgColor

        frontPanel.isHidden = false

        update()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "frontSegue" {
            frontVC = segue.destination as? FrontViewController
        } else if segue.identifier == "solarSegue" {
            solarVC = segue.destination as? SolarViewController
        } else if segue.identifier == "detailsSegue" {
            detailsVC = segue.destination as? DetailsViewController
        } else if segue.identifier == "settingsSegue" {
            settingsVC = segue.destination as? SettingsViewController
        }
    }
    // MARK: - IBActions.

    @IBAction func selectLocation(_ sender: UIButton) {
        performSegue(withIdentifier: "segueToLocationList", sender: nil)
    }

    /// Called when unwinding a segue back to this view.
    ///
    /// - Parameter segue: The segue being unwound.
    ///
    @IBAction func unwindToMainVC(segue: UIStoryboardSegue) {
        switch segue.source {
        case is LocationListViewController:
            update()
        case is SettingsViewController:
            flip(frontPanel, rearView: settingsPanel)
            update()
        case is SolarViewController:
            flip(frontPanel, rearView: solarPanel)
        case is DetailsViewController:
            flip(frontPanel, rearView: detailsPanel)
        default:
            break
        }
    }

    // MARK: - Local functions.

    private func update() {
        if let place = PlaceManager.retrieveDefaultPlace() {
            updateWeather(for: place)
        } else {
            locationController = LocationController(withDelegate: self)
            locationController?.requestLocation()
        }
    }

    fileprivate func updateWeather(for place: Place) {
        let darkSky = DarkSkyClient(location: Location(latitude: place.latitude, longitude: place.longitude))
        darkSky.fetchForecast { darkSkyForecast in
            DispatchQueue.main.async {
                self.updateDisplay(with: darkSkyForecast, for: place)
                self.frontVC?.update(forecast: darkSkyForecast,
                                     foregroundColor: self.currentWeatherSymbol.textColor,
                                     backgroundColor: self.currentWeatherSymbol.backgroundColor,
                                     container: self)
                self.settingsVC?.update(forecast: darkSkyForecast,
                                        foregroundColor: self.currentWeatherSymbol.textColor!,
                                        backgroundColor: self.currentWeatherSymbol.backgroundColor!)
                self.solarVC?.update(forecast: darkSkyForecast,
                                     foregroundColor: self.currentWeatherSymbol.textColor!,
                                     backgroundColor: self.currentWeatherSymbol.backgroundColor!)
                self.detailsVC?.update(forecast: darkSkyForecast,
                                       foregroundColor: self.currentWeatherSymbol.textColor!,
                                       backgroundColor: self.currentWeatherSymbol.backgroundColor!)
            }
        }
    }

    private func updateDisplay(with forecast: DarkSkyForecast, for place: Place) {
        uiPlace.text = place.region != "" ? place.region : place.name
        updateWeather(using: forecast.current?.icon)

        viewB.backgroundColor = currentWeatherSymbol.backgroundColor
        currentWeatherSymbol.textColor = currentWeatherSymbol.textColor

        minuteSummary.text = forecast.minutely?.summary ?? ""
        hourSummary.text   = forecast.hourly?.summary ?? ""
    }

    private func updateWeather(using icon: String?) {
        let weather = Weather.representedBy(darkSkyIcon: icon ?? "")
        currentWeatherSymbol.text = weather.symbol
        currentWeatherSymbol.backgroundColor = weather.color
        if weather.isDark {
            currentWeatherSymbol.textColor = UIColor.white
            self.view.backgroundColor = weather.color.lighter().lighter()
        } else {
            currentWeatherSymbol.textColor = UIColor.black
            self.view.backgroundColor = weather.color.darker().darker()
        }
    }

    func flip(_ frontView: UIView, rearView: UIView) {
        if rearView.isHidden {
            let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
            UIView.transition(with: frontView, duration: 1.0, options: transitionOptions,
                              animations: { frontView.isHidden = true  }, completion: nil)
            UIView.transition(with: rearView, duration: 1.0, options: transitionOptions,
                              animations: { rearView.isHidden  = false }, completion: nil)
        } else {
            let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromLeft, .showHideTransitionViews]
            UIView.transition(with: rearView, duration: 1.0, options: transitionOptions,
                              animations: { rearView.isHidden  = true  }, completion: nil)
            UIView.transition(with: frontView, duration: 1.0, options: transitionOptions,
                              animations: { frontView.isHidden = false }, completion: nil)
        }
    }
}

extension MainViewController: LocationControllerDelegate {

    func locationController(_ locationController: LocationController, didUpdateLocation location: Location) {
        let place = Place(name: "Around here...", region: "", placeID: "",
                          latitude: location.latitude, longitude: location.longitude)
        updateWeather(for: place)
    }

    func locationController(_ locationController: LocationController, didFailWithError error: Error) {
        let msg = "No weather forecast available at the moment.\n\n\(error)"
        let alertController = UIAlertController(title: "Current Weather", message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
