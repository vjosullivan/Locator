//
//  MainViewController.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 12/11/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

enum WeatherIcon: String {
    case rain  = "\u{F019}"
    case snow  = "\u{F01B}"
    case sleet = "\u{F0B5}"
    case wind  = "\u{F050}"
    case fog   = "\u{F014}"
    case clearDay   = "\u{F00D}"
    case clearNight = "\u{F02E}"
    case cloudy     = "\u{F013}"
    case partlyCloudyDay   = "\u{F002}"
    case partlyCloudyNight = "\u{F086}"
    case hail         = "\u{F015}"
    case thunderstorm = "\u{F01E}"
    case tornado      = "\u{F056}"
    case noWeather =  "\u{F095}"

    case windDirection   = "\u{F0B1}"
    case barometer       = "\u{F079}"

    case thermometer    = "\u{F055}"
    case thermometerIn  = "\u{F054}"
    case thermometerOut = "\u{F053}"

    static let windCalm = WeatherIcon(rawValue: "\u{F095}")!
}

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
        _ = backgroundColoredViews.map{ $0.backgroundColor = UIColor.clear }

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
        
        placeVertical(text: "Settings",   on: buttonATL, using: labelATL)
        placeVertical(text: "Location",   on: buttonATR, using: labelATR, rotateClockwise: false)
        placeVertical(text: "Daylight", on: buttonABL, using: labelABL)
        placeVertical(text: "Details",    on: buttonABR, using: labelABR, rotateClockwise: false)
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
        print("A")
        if segue.identifier == "solarSegue" {
            print("B")
            solarVC = segue.destination as? SolarViewController
        } else if segue.identifier == "detailsSegue" {
            print("C")
            detailsVC = segue.destination as? DetailsViewController
        } else if segue.identifier == "settingsSegue" {
            print("D")
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
        print("Unwinding...")
        switch segue.source {
        case is LocationListViewController:
            print("Unwound from location controller")
            update()
        case is SettingsViewController:
            print("Unwound from settings controller")
            flip(frontPanel, rearView: settingsPanel)
        case is SolarViewController:
            print("Unwound from solar controller")
            flip(frontPanel, rearView: solarPanel)
        case is DetailsViewController:
            print("Unwound from details controller")
            flip(frontPanel, rearView: detailsPanel)
        default:
            break
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
        print("Update display.")
        // TODO: Incorporate location info into forecast.
//        if let place = PlaceManager.retrieveDefaultPlace() {
        uiPlace.text = place.region != "" ? place.region : place.name
        currentWeatherSymbol.textColor = UIColor.black
        if let weatherIcon = forecast.current?.icon {
            switch weatherIcon {
            case "clear-day":
                currentWeatherSymbol.text = WeatherIcon.clearDay.rawValue
                currentWeatherSymbol.backgroundColor = UIColor.clearDay
                self.view.backgroundColor = currentWeatherSymbol.backgroundColor?.darker().darker()
            case "clear-night":
                currentWeatherSymbol.text = WeatherIcon.clearNight.rawValue
                currentWeatherSymbol.backgroundColor = UIColor.clearNight
                currentWeatherSymbol.textColor = UIColor.white
                self.view.backgroundColor = currentWeatherSymbol.backgroundColor?.lighter().lighter()
            case "rain":
                currentWeatherSymbol.text = WeatherIcon.rain.rawValue
                currentWeatherSymbol.backgroundColor = UIColor.rainDay
                currentWeatherSymbol.textColor = UIColor.white
                self.view.backgroundColor = currentWeatherSymbol.backgroundColor?.darker().darker()
            case "snow":
                currentWeatherSymbol.text = WeatherIcon.snow.rawValue
                currentWeatherSymbol.backgroundColor = UIColor.snowDay
                self.view.backgroundColor = currentWeatherSymbol.backgroundColor?.darker().darker()
            case "sleet":
                currentWeatherSymbol.text = WeatherIcon.sleet.rawValue
                currentWeatherSymbol.backgroundColor = UIColor.sleetDay
                currentWeatherSymbol.textColor = UIColor.white
                self.view.backgroundColor = currentWeatherSymbol.backgroundColor?.darker().darker()
            case "wind":
                currentWeatherSymbol.text = WeatherIcon.wind.rawValue
                currentWeatherSymbol.backgroundColor = UIColor.windDay
                currentWeatherSymbol.textColor = UIColor.white
                self.view.backgroundColor = currentWeatherSymbol.backgroundColor?.darker().darker()
            case "fog":
                currentWeatherSymbol.text = WeatherIcon.fog.rawValue
                currentWeatherSymbol.backgroundColor = UIColor.fogDay
                currentWeatherSymbol.textColor = UIColor.white
                self.view.backgroundColor = currentWeatherSymbol.backgroundColor?.darker().darker()
            case "cloudy":
                currentWeatherSymbol.text = WeatherIcon.cloudy.rawValue
                currentWeatherSymbol.backgroundColor = UIColor.cloudyDay
                currentWeatherSymbol.textColor = UIColor.white
                self.view.backgroundColor = currentWeatherSymbol.backgroundColor?.darker().darker()
            case "partly-cloudy-day":
                currentWeatherSymbol.text = WeatherIcon.partlyCloudyDay.rawValue
                currentWeatherSymbol.backgroundColor = UIColor.partlyCloudyDay
                currentWeatherSymbol.textColor = UIColor.white
                self.view.backgroundColor = currentWeatherSymbol.backgroundColor?.darker().darker()
            case "partly-cloudy-night":
                currentWeatherSymbol.text = WeatherIcon.partlyCloudyNight.rawValue
                currentWeatherSymbol.backgroundColor = UIColor.partlyCloudyNight
                currentWeatherSymbol.textColor = UIColor.white
                self.view.backgroundColor = currentWeatherSymbol.backgroundColor?.lighter().lighter()
            case "hail":
                currentWeatherSymbol.text = WeatherIcon.hail.rawValue
                currentWeatherSymbol.backgroundColor = UIColor.hailDay
                currentWeatherSymbol.textColor = UIColor.white
                self.view.backgroundColor = currentWeatherSymbol.backgroundColor?.darker().darker()
            case "thunderstorm":
                currentWeatherSymbol.text = WeatherIcon.thunderstorm.rawValue
                currentWeatherSymbol.backgroundColor = UIColor.thunderstormDay
                currentWeatherSymbol.textColor = UIColor.white
                self.view.backgroundColor = currentWeatherSymbol.backgroundColor?.darker().darker()
            case "tornado":
                currentWeatherSymbol.text = WeatherIcon.tornado.rawValue
                currentWeatherSymbol.backgroundColor = UIColor.thunderstormNight
                currentWeatherSymbol.textColor = UIColor.white
                self.view.backgroundColor = currentWeatherSymbol.backgroundColor?.darker().darker()
            default:
                currentWeatherSymbol.text = WeatherIcon.noWeather.rawValue
                currentWeatherSymbol.backgroundColor = UIColor.noWeatherDay
                currentWeatherSymbol.textColor = UIColor.white
                self.view.backgroundColor = currentWeatherSymbol.backgroundColor?.darker().darker()
            }
            viewA.backgroundColor = currentWeatherSymbol.backgroundColor
            viewB.backgroundColor = currentWeatherSymbol.backgroundColor
            currentWeatherValue.textColor  = currentWeatherSymbol.textColor
            currentTemperatureValue.textColor = currentWeatherSymbol.textColor
            todaysHighValue.textColor = currentWeatherSymbol.textColor
            todaysLowValue.textColor = currentWeatherSymbol.textColor
            print("Wahey!")
            labelATL.textColor = currentWeatherSymbol.textColor
            labelATR.textColor = currentWeatherSymbol.textColor
            labelABL.textColor = currentWeatherSymbol.textColor
            labelABR.textColor = currentWeatherSymbol.textColor
            buttonATR.layer.borderColor = currentWeatherSymbol.backgroundColor?.darker().cgColor
            buttonABR.layer.borderColor = currentWeatherSymbol.backgroundColor?.darker().cgColor
            buttonATL.layer.borderColor = currentWeatherSymbol.backgroundColor?.darker().cgColor
            buttonABL.layer.borderColor = currentWeatherSymbol.backgroundColor?.darker().cgColor
        } else {
            currentWeatherSymbol.text = WeatherIcon.noWeather.rawValue
        }
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
        } else {
            todaysHighValue.text = ""
        }
        if let lo = forecast.today?.apparentTemperatureMin {
            todaysLowValue.text = "\(Int(lo.value))\(lo.unit.symbol)"
        } else {
            todaysLowValue.text = ""
        }
        minuteSummary.text = forecast.minutely?.summary ?? ""
        hourSummary.text   = forecast.hourly?.summary ?? ""
    }
    
    fileprivate func flip(_ frontView: UIView, rearView: UIView) {
        print("Flip: Front visible = \(frontView.isHidden), rear visible = \(rearView.isHidden).")
        if rearView.isHidden {
            print("Making rear view visible")
            let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
            UIView.transition(with: frontView, duration: 1.0, options: transitionOptions, animations: { frontView.isHidden = true  }, completion: nil)
            UIView.transition(with: rearView,  duration: 1.0, options: transitionOptions, animations: { rearView.isHidden  = false }, completion: nil)
        } else {
            print("Making front view visible")
            let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromLeft, .showHideTransitionViews]
            UIView.transition(with: rearView,  duration: 1.0, options: transitionOptions, animations: { rearView.isHidden  = true  }, completion: nil)
            UIView.transition(with: frontView, duration: 1.0, options: transitionOptions, animations: { frontView.isHidden = false }, completion: nil)
        }
    }
}

extension MainViewController: LocationControllerDelegate {

    func location(controller: LocationController, didUpdateLocation location: Location) {
        print("Location found.")
        let place = Place(name: "Around here...", region: "", placeID: "", latitude: location.latitude, longitude: location.longitude)
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

