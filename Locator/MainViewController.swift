//
//  MainViewController.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 12/11/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {

    let radianConvertion = CGFloat.pi / 180.0
    private let cornerRadius: CGFloat = 16.0

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

        //       update()
    }

    override func viewDidAppear(_ animated: Bool) {
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
            self.updateForcast(using: darkSkyForecast, for: place)
        }
    }

    private func updateForcast(using forecast: DarkSkyForecast, for place: Place) {
        DispatchQueue.main.async {
            let pageColor = UIColor.randomPastel()
            self.updateCurrentWeather(with: forecast, for: place, in: pageColor)
            self.frontVC?.configure(presenter: FrontViewPresenter(forecast: forecast),
                                    backgroundColor: pageColor,
                                    cornerRadius: self.cornerRadius,
                                    container: self)
            //self.frontVC?.updateData(forecast: darkSkyForecast)
            self.settingsVC?.update(forecast: forecast,
                                    backgroundColor: pageColor,
                                    cornerRadius: self.cornerRadius)
            self.solarVC?.update(forecast: forecast,
                                 backgroundColor: pageColor,
                                 cornerRadius: self.cornerRadius)
            self.detailsVC?.update(forecast: forecast,
                                   backgroundColor: pageColor,
                                   cornerRadius: self.cornerRadius)
            self.hourVC?.update(forecast: forecast,
                                backgroundColor: pageColor,
                                cornerRadius: self.cornerRadius)
            self.dayVC?.update(forecast: forecast,
                               backgroundColor: pageColor,
                               cornerRadius: self.cornerRadius, container: self)
            self.weekVC?.update(forecast: forecast,
                                backgroundColor: pageColor,
                                cornerRadius: self.cornerRadius)
            self.creditsVC?.update(forecast: forecast,
                                   backgroundColor: pageColor,
                                   cornerRadius: self.cornerRadius)
            self.alertsVC?.update(forecast: forecast,
                                  backgroundColor: pageColor,
                                  cornerRadius: self.cornerRadius)
        }
    }

    private func updateCurrentWeather(with forecast: DarkSkyForecast, for place: Place, in color: UIColor) {
        locationLabel.text = place.region != "" ? place.region : place.name
        let weather = Weather.representedBy(darkSkyIcon: forecast.current?.icon ?? "")
        currentWeatherSymbol.text = weather.symbol
        currentWeatherBackground.backgroundColor = color
        let darkWeatherColor = (weather.color != UIColor.yellow) ? weather.color.darker(by: 0.33) : weather.color
        currentWeatherSymbol.textColor = darkWeatherColor

        addImageToBackground(backgroundColor: color.darker)
    }

    private struct Layer {
        static var index = -1
    }

    private func index() -> Int {
        Layer.index += 1
        return Layer.index
    }

    private func addImageToBackground(backgroundColor: UIColor) {
        let imageSize = CGSize(width: self.view.frame.maxX, height: self.view.frame.maxY)
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: imageSize))
        self.view.insertSubview(imageView, at: index())
        let image = drawCustomImage(size: imageSize, foreground: backgroundColor.lighter(by: 0.33) , background: backgroundColor.darker)
        imageView.image = image
        self.view.backgroundColor = backgroundColor
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
        context.setLineWidth(0.5)

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

        UIView.animate(withDuration: 1.0) { () -> Void in
            self.currentWeatherSymbol.layer.transform = CATransform3DMakeRotation(CGFloat.pi * 1, 0, 0, 1)
        }
        UIView.animate(withDuration: 1.0) { () -> Void in
            self.currentWeatherSymbol.layer.transform = CATransform3DMakeRotation(0.0, 0, 0, 1)
        }
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
        let place = Place(name: "Right Here · Right Now", region: "", placeID: "",
                          latitude: location.latitude, longitude: location.longitude)
        updateWeather(for: place)
    }

    func locationController(_ locationController: LocationController, didFailWithError error: Error) {
        print("MainViewController: Location controller did fail with error \(error.localizedDescription).")
        if let status = (error as? LocationStatus) {
            switch status {
            case .authorityDenied:
                requestUpdateApplicationSetting()
            case .authorityRestricted:
                displayRestrictedAlert()
            case .serviceNotEnabled:
                requestUpdatePrivacySettings()
            }
        } else {
            let msg = "Unable to determine current location.  Please try later.\n\n\(error)"
            let alertController = UIAlertController(title: "Location Services Disabled", message: msg, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    private func requestUpdatePrivacySettings() {
        let alertController = UIAlertController(
            title: "Location Tracking Disabled",
            message: "This device is not currently tracking it's location.\n\n"
                + "To enable weather forecasting for your current location, "
                + "open this device's location settings and enable 'Location Services'.",
            preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (_) in

            if let url = URL(string: "App-Prefs:root=LOCATION_SERVICES") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)

        self.present(alertController, animated: true, completion: nil)
    }

    private func requestUpdateApplicationSetting() {
        let alertController = UIAlertController(
            title: "Location Tracking Denied",
            message: "Raincoat is not currently tracking this device's location.\n\n"
                + "To enable weather forecasting for your current location, "
                + "open this app's settings and set location access to 'Always'.",
            preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (_) in

            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)

        self.present(alertController, animated: true, completion: nil)
    }

    private func displayRestrictedAlert() {
        let alertController = UIAlertController(
            title: "Background Location Access Restricted",
            message: "Sorry.  This application is not permitted to access location information on this device.",
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
