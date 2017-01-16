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

    @IBOutlet weak var viewA: UIView!
    @IBOutlet weak var currentWeatherSymbol: UILabel!
    @IBOutlet weak var currentWeatherValue: UILabel!
    @IBOutlet weak var currentTemperatureValue: UILabel!
    @IBOutlet weak var todaysHighValue: UILabel!
    @IBOutlet weak var todaysLowValue: UILabel!
    @IBOutlet weak var highIcon: UILabel!
    @IBOutlet weak var lowIcon: UILabel!

    @IBOutlet weak var buttonATR: UIButton!
    @IBOutlet weak var labelATR: UILabel!
    @IBOutlet weak var buttonATL: UIButton!
    @IBOutlet weak var labelATL: UILabel!
    @IBOutlet weak var buttonABR: UIButton!
    @IBOutlet weak var labelABR: UILabel!
    @IBOutlet weak var buttonABL: UIButton!
    @IBOutlet weak var labelABL: UILabel!
    @IBOutlet weak var buttonBTR: UIButton!
    @IBOutlet weak var buttonBTL: UIButton!
    @IBOutlet weak var buttonBBR: UIButton!
    @IBOutlet weak var buttonBBL: UIButton!

    @IBOutlet weak var frontPanel: UIView!

    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var settingsPanel: UIView!
    @IBOutlet weak var solarPanel: UIView!
    @IBOutlet weak var detailsPanel: UIView!

    private var settingsVC: SettingsViewController?
    private var solarVC: SolarViewController?
    private var detailsVC: DetailsViewController?

    private var locationController: LocationController?

    @IBOutlet weak var viewB: UIView!

    // MARK: - UIViewController functions.

    override func viewDidLoad() {
        super.viewDidLoad()

        // Clear background colors from labels and buttons
        _ = backgroundColoredViews.map { $0.backgroundColor = UIColor.clear }

        buttonATR.layer.borderColor = UIColor.lightGray.cgColor
        buttonABR.layer.borderColor = UIColor.lightGray.cgColor
        buttonATL.layer.borderColor = UIColor.lightGray.cgColor
        buttonABL.layer.borderColor = UIColor.lightGray.cgColor
        buttonBTR.layer.borderColor = UIColor.lightGray.cgColor
        buttonBBR.layer.borderColor = UIColor.lightGray.cgColor
        buttonBTL.layer.borderColor = UIColor.lightGray.cgColor
        buttonBBL.layer.borderColor = UIColor.lightGray.cgColor

        buttonATR.imageView?.contentMode = .scaleAspectFit

        update()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        placeVertical(text: "Settings", on: buttonATL, using: labelATL)
        placeVertical(text: "Location", on: buttonATR, using: labelATR, rotateClockwise: false)
        placeVertical(text: "Daylight", on: buttonABL, using: labelABL)
        placeVertical(text: "Details", on: buttonABR, using: labelABR, rotateClockwise: false)
    }

    private func placeVertical(text: String, on button: UIButton, using label: UILabel, rotateClockwise: Bool = true) {
        label.frame = CGRect(x: 0.0, y: 0.0, width: button.frame.width, height: button.frame.height)
        button.addSubview(label)
        let angle = rotateClockwise ? CGFloat(M_PI_2) : -CGFloat(M_PI_2)  // +/- 90°.
        label.transform = CGAffineTransform.init(rotationAngle: angle)
        label.textColor = button.currentTitleColor
        label.backgroundColor = UIColor.clear
        label.text = text
        label.font = button.titleLabel?.font
        label.textAlignment = .center
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "solarSegue" {
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
        if sender == locationButton {
            displayScreen(sender)
        }
    }

    @IBAction func displayScreen(_ sender: UIButton) {
        print("\nButton action!")
        switch true {
        case sender == buttonATL || !settingsPanel.isHidden:
            flip(frontPanel, rearView: settingsPanel)
        case sender == buttonABL || !solarPanel.isHidden:
            flip(frontPanel, rearView: solarPanel)
        case sender == buttonABR || !detailsPanel.isHidden:
            flip(frontPanel, rearView: detailsPanel)
        default:
            break
        }
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

        viewA.backgroundColor = currentWeatherSymbol.backgroundColor
        viewB.backgroundColor = currentWeatherSymbol.backgroundColor
        currentWeatherSymbol.textColor  = currentWeatherSymbol.textColor
        currentTemperatureValue.textColor = currentWeatherSymbol.textColor
        todaysHighValue.textColor = currentWeatherSymbol.textColor
        todaysLowValue.textColor = currentWeatherSymbol.textColor
        highIcon.textColor = UIColor.red
        lowIcon.textColor = UIColor.blue

        labelATL.textColor = currentWeatherSymbol.textColor
        labelATR.textColor = currentWeatherSymbol.textColor
        labelABL.textColor = currentWeatherSymbol.textColor
        labelABR.textColor = currentWeatherSymbol.textColor
        buttonATR.layer.borderColor = currentWeatherSymbol.backgroundColor?.darker().cgColor
        buttonABR.layer.borderColor = currentWeatherSymbol.backgroundColor?.darker().cgColor
        buttonATL.layer.borderColor = currentWeatherSymbol.backgroundColor?.darker().cgColor
        buttonABL.layer.borderColor = currentWeatherSymbol.backgroundColor?.darker().cgColor

        if let summary = forecast.current?.summary {
            currentWeatherValue.text = "\(summary)"
        } else {
            currentWeatherValue.text = "Unknown."
        }
        if let temperature = forecast.current?.temperature {
            currentTemperatureValue.text  = "\(Int(round(temperature.value)))\(temperature.unit.symbol)"
        } else {
            currentTemperatureValue.text  = ""
        }
        if let hi = forecast.today?.apparentTemperatureMax {
            todaysHighValue.text = "\(Int(hi.value))\(hi.unit.symbol)"
            highIcon.text = "\u{F055}"
        } else {
            todaysHighValue.text = " "
            highIcon.text = " "
        }
        if let lo = forecast.today?.apparentTemperatureMin {
            todaysLowValue.text = "\(Int(lo.value))\(lo.unit.symbol)"
            lowIcon.text = "\u{F053}"
        } else {
            todaysLowValue.text = " "
            lowIcon.text = " "
        }
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

    fileprivate func flip(_ frontView: UIView, rearView: UIView) {
        print("Flip: Front visible = \(frontView.isHidden), rear visible = \(rearView.isHidden).")
        if rearView.isHidden {
            print("Making rear view visible")
            let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
            UIView.transition(with: frontView, duration: 1.0, options: transitionOptions,
                              animations: { frontView.isHidden = true  }, completion: nil)
            UIView.transition(with: rearView, duration: 1.0, options: transitionOptions,
                              animations: { rearView.isHidden  = false }, completion: nil)
        } else {
            print("Making front view visible")
            let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromLeft, .showHideTransitionViews]
            UIView.transition(with: rearView, duration: 1.0, options: transitionOptions,
                              animations: { rearView.isHidden  = true  }, completion: nil)
            UIView.transition(with: frontView, duration: 1.0, options: transitionOptions,
                              animations: { frontView.isHidden = false }, completion: nil)
        }
    }
}

extension MainViewController: LocationControllerDelegate {

    func location(controller: LocationController, didUpdateLocation location: Location) {
        let place = Place(name: "Around here...", region: "", placeID: "",
                          latitude: location.latitude, longitude: location.longitude)
        updateWeather(for: place)
    }

    func location(controller: LocationController, didFailWithError error: Error) {
        let msg = "No weather forecast available at the moment.\n\n\(error)"
        let alertController = UIAlertController(title: "Current Weather", message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
