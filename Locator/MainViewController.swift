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

    @IBOutlet weak var rainIntensity: GraphView!
    @IBOutlet weak var rainProbability: GraphView!

    // These views have coloured backgrounds in the storyboard which are cleared when run.
    @IBOutlet var backgroundColoredViews: [UIView]!

    @IBOutlet weak var locationLabel: RibbonView!

    @IBOutlet weak var currentWeatherSymbol: UILabel!
    @IBOutlet weak var currentWeatherBackground: UILabel!

    @IBOutlet weak var frontPanel: UIView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var settingsPanel: UIView!
    @IBOutlet weak var solarPanel: UIView!
    @IBOutlet weak var detailsPanel: UIView!

    @IBOutlet weak var dayPanel: UIView!
    @IBOutlet weak var weekPanel: UIView!
    @IBOutlet weak var creditsPanel: UIView!
    @IBOutlet weak var hourPanel: UIView!
    @IBOutlet weak var alertsPanel: UIView!

    private var frontVC: FrontViewController?
    private var settingsVC: SettingsViewController?
    private var solarVC: SolarViewController?
    private var detailsVC: DetailsViewController?

    private var hourVC: HourViewController?
    private var dayVC: DayViewController?
    private var weekVC: WeekViewController?
    private var creditsVC: CreditsViewController?
    private var alertsVC: AlertsViewController?

    private var locationController: LocationController?

    // MARK: - UIViewController functions.

    override func viewDidLoad() {
        super.viewDidLoad()

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
        } else if segue.identifier == "hourViewSegue" {
            hourVC = segue.destination as? HourViewController
        } else if segue.identifier == "dayViewSegue" {
            dayVC = segue.destination as? DayViewController
        } else if segue.identifier == "weekViewSegue" {
            weekVC = segue.destination as? WeekViewController
        } else if segue.identifier == "creditsViewSegue" {
            creditsVC = segue.destination as? CreditsViewController
        } else if segue.identifier == "alertsViewSegue" {
            alertsVC = segue.destination as? AlertsViewController
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
        case is HourViewController:
            flip(dayPanel, rearView: hourPanel)
        case is WeekViewController:
            flip(dayPanel, rearView: weekPanel)
        case is CreditsViewController:
            flip(dayPanel, rearView: creditsPanel)
        case is AlertsViewController:
            flip(dayPanel, rearView: alertsPanel)
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
                                     backgroundColor: self.currentWeatherBackground.backgroundColor,
                                     container: self)
                self.settingsVC?.update(forecast: darkSkyForecast,
                                        foregroundColor: self.currentWeatherSymbol.textColor,
                                        backgroundColor: self.currentWeatherBackground.backgroundColor)
                self.solarVC?.update(forecast: darkSkyForecast,
                                     foregroundColor: self.currentWeatherSymbol.textColor,
                                     backgroundColor: self.currentWeatherBackground.backgroundColor)
                self.detailsVC?.update(forecast: darkSkyForecast,
                                       foregroundColor: self.currentWeatherSymbol.textColor,
                                       backgroundColor: self.currentWeatherBackground.backgroundColor)
                self.hourVC?.update(forecast: darkSkyForecast,
                                    foregroundColor: self.currentWeatherSymbol.textColor,
                                    backgroundColor: self.currentWeatherBackground.backgroundColor)
                self.dayVC?.update(forecast: darkSkyForecast,
                                    foregroundColor: self.currentWeatherSymbol.textColor,
                                    backgroundColor: self.currentWeatherBackground.backgroundColor, container: self)
                self.weekVC?.update(forecast: darkSkyForecast,
                                    foregroundColor: self.currentWeatherSymbol.textColor,
                                    backgroundColor: self.currentWeatherBackground.backgroundColor)
                self.creditsVC?.update(forecast: darkSkyForecast,
                                    foregroundColor: self.currentWeatherSymbol.textColor,
                                    backgroundColor: self.currentWeatherBackground.backgroundColor)
                self.alertsVC?.update(forecast: darkSkyForecast,
                                      foregroundColor: self.currentWeatherSymbol.textColor,
                                      backgroundColor: self.currentWeatherBackground.backgroundColor)
            }
        }
    }

    private func updateDisplay(with forecast: DarkSkyForecast, for place: Place) {
        locationLabel.text = place.region != "" ? place.region : place.name
        updateWeather(using: forecast.current?.icon)
    }

    private func updateWeather(using icon: String?) {
        let weather = Weather.representedBy(darkSkyIcon: icon ?? "")
        currentWeatherSymbol.text = weather.symbol
        currentWeatherBackground.backgroundColor = weather.color
        currentWeatherSymbol.textColor = weather.isDark ? UIColor.white : UIColor.black
        addImageToBackground(foreground: UIColor(white: 1.0, alpha: 0.125),
                       background: weather.color.darker())
    }

    private struct Layer {
        static var index = -1
    }

    private func index() -> Int {
        Layer.index += 1
        return Layer.index
    }

    /// Adds a prepared image to the background.
    ///
    /// - Parameters:
    ///   - foreground: Foreground color
    ///   - background: <#background description#>
    private func addImageToBackground(foreground: UIColor, background: UIColor) {
        let imageSize = CGSize(width: self.view.frame.maxX, height: self.view.frame.maxY)
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: imageSize))
        self.view.insertSubview(imageView, at: index())
        let image = drawCustomImage(size: imageSize, foreground: foreground, background: background)
        imageView.image = image
        self.view.backgroundColor = background
    }

    func drawCustomImage(size: CGSize, foreground: UIColor, background: UIColor) -> UIImage? {
        // Setup our context
        let bounds = CGRect(origin: CGPoint.zero, size: size)
        let opaque = false
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        // Setup complete, do drawing here
        context.setStrokeColor(foreground.cgColor)
        context.setLineWidth(1.0)

        // Would draw a border around the rectangle
        // context.stroke(bounds)

        context.beginPath()
        var x = 0.0
        let xIncrement = 12.0 //Swift.max(8, Double(bounds.maxY) / 16.0)
        while x < Double(bounds.maxX + bounds.maxY) {
            x += xIncrement
            context.move(to: CGPoint(x: x, y: 0.0))
            context.addLine(to: CGPoint(x: 0.0, y: x))
        }
        context.strokePath()

        // Drawing complete, retrieve the finished image and cleanup
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
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
