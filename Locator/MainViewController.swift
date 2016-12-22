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

    @IBOutlet weak var currentWeatherSymbol: UILabel!
    @IBOutlet weak var currentWeatherValue: UILabel!
    @IBOutlet weak var currentWindDirectionSymbol: UILabel!
    @IBOutlet weak var currentWindDirectionValue: UILabel!
    @IBOutlet weak var currentBarometerSymbol: UILabel!
    @IBOutlet weak var currentBarometerValue: UILabel!
    @IBOutlet weak var currentTemperatureSymbol: UILabel!
    @IBOutlet weak var currentTemperatureValue: UILabel!

    @IBOutlet weak var buttonATR: UIButton!
    @IBOutlet weak var buttonATL: UIButton!
    @IBOutlet weak var buttonABR: UIButton!
    @IBOutlet weak var buttonABL: UIButton!
    @IBOutlet weak var buttonBTR: UIButton!
    @IBOutlet weak var buttonBTL: UIButton!
    @IBOutlet weak var buttonBBR: UIButton!
    @IBOutlet weak var buttonBBL: UIButton!

    private var locationController: LocationController?

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
        if let weatherIcon = forecast.current?.icon {
            switch weatherIcon {
            case "clear-day":
                currentWeatherSymbol.text = WeatherIcon.clearDay.rawValue
            case "clear-night":
                currentWeatherSymbol.text = WeatherIcon.clearNight.rawValue
            case "rain":
                currentWeatherSymbol.text = WeatherIcon.rain.rawValue
            case "snow":
                currentWeatherSymbol.text = WeatherIcon.snow.rawValue
            case "sleet":
                currentWeatherSymbol.text = WeatherIcon.sleet.rawValue
            case "wind":
                currentWeatherSymbol.text = WeatherIcon.wind.rawValue
            case "fog":
                currentWeatherSymbol.text = WeatherIcon.fog.rawValue
            case "cloudy":
                currentWeatherSymbol.text = WeatherIcon.cloudy.rawValue
            case "partly-cloudy-day":
                currentWeatherSymbol.text = WeatherIcon.partlyCloudyDay.rawValue
            case "partly-cloudy-night":
                currentWeatherSymbol.text = WeatherIcon.partlyCloudyNight.rawValue
            case "hail":
                currentWeatherSymbol.text = WeatherIcon.hail.rawValue
            case "thunderstorm":
                currentWeatherSymbol.text = WeatherIcon.thunderstorm.rawValue
            case "tornado":
                currentWeatherSymbol.text = WeatherIcon.tornado.rawValue
            default:
                currentWeatherSymbol.text = WeatherIcon.noWeather.rawValue
            }
        } else {
            currentWeatherSymbol.text = WeatherIcon.noWeather.rawValue
        }
        if let summary = forecast.current?.summary {
            currentWeatherValue.text = "\(summary)."
        } else {
            currentWeatherValue.text = "Unknown."
        }
        if let windDirection = forecast.current?.windBearing?.value {
            currentWindDirectionSymbol.text = WeatherIcon.windDirection.rawValue
            currentWindDirectionSymbol.transform = CGAffineTransform(rotationAngle: radianConvertion * CGFloat(windDirection))
        } else {
            currentWindDirectionSymbol.text = WeatherIcon.windCalm.rawValue
        }
        if let windSpeed = forecast.current?.windSpeed {
            currentWindDirectionValue.text = windSpeed.value > 0 ? windSpeed.description : "Calm"
        } else {
            currentWindDirectionValue.text = ""
        }
        if let pressure = forecast.current?.pressure {
            currentBarometerSymbol.text = WeatherIcon.barometer.rawValue
            currentBarometerValue.text  = pressure.description
        } else {
            currentBarometerSymbol.text = ""
            currentBarometerValue.text  = ""
        }
        if let temperature = forecast.current?.temperature {
            currentTemperatureValue.text  = "\(temperature.value)°"
        } else {
            currentTemperatureValue.text  = ""
        }
        minuteSummary.text = forecast.minutely?.summary ?? ""
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

