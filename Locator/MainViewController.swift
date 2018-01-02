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

    // MARK: - Local constants and variables.

    let radianConvertion = CGFloat.pi / 180.0
    private let cornerRadius: CGFloat = MainViewController.deviceIsIPhoneX ? 42 : 12

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

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

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

    override func prefersHomeIndicatorAutoHidden() -> Bool {
        return true
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
        activityIndicator.startAnimating()
        //locationLabel.text = "·"
        darkSky.fetchForecast(
            completionHandler: { darkSkyForecast in
                self.updateForcast(using: darkSkyForecast, for: place)},
            errorHandler: { errorText in
                let alertController = UIAlertController(
                    title: "No Weather Today",
                    message: "Either there is no weather today or there is a problem with your Internet connection or something."
                        + "\n⋅\nThis message cropped up instead:\n\"\(errorText)\""
                        + "\n⋅\nCheck everything and try again." + "\n",
                    preferredStyle: .alert)

                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                self.locationLabel.text = "Tap to try again."
                self.activityIndicator.stopAnimating()
        }
        )
    }

    private func updateForcast(using forecast: DarkSkyForecast, for place: Place) {
        DispatchQueue.main.async {
            let displayOption1: DisplayOption1
            switch AppSettings.retrieve(key: "option1", defaultValue: "wind") {
            case "uvIndex":
                displayOption1 = .light
            default:
                displayOption1 = .wind
            }
            let pageColor = UIColor.randomPastel()
            self.locationLabel.backgroundColor = pageColor
            self.updateCurrentWeather(with: forecast, for: place, in: pageColor)
            self.frontVC?.configure(presenter: FrontViewPresenter(forecast: forecast, clock: SystemClock()),
                                    backgroundColor: pageColor,
                                    cornerRadius: self.cornerRadius,
                                    container: self)
            //self.frontVC?.updateData(forecast: darkSkyForecast)
            self.settingsVC?.update(forecast: forecast,
                                    backgroundColor: pageColor,
                                    cornerRadius: self.cornerRadius)
            self.solarVC?.backgroundColor = pageColor
            self.solarVC?.cornerRadius    = self.cornerRadius
            self.solarVC?.viewModel       = SolarViewModel(with: forecast, clock: SystemClock())
            self.detailsVC?.configure(presenter: DetailsPresenter(forecast: forecast, clock: SystemClock()),
                                      backgroundColor: pageColor,
                                      cornerRadius: self.cornerRadius)
            self.hourVC?.update(forecast: forecast,
                                backgroundColor: pageColor,
                                cornerRadius: self.cornerRadius)
            self.dayVC?.update(forecast: forecast,
                               backgroundColor: pageColor,
                               cornerRadius: self.cornerRadius, container: self, displayOption1: displayOption1)
            self.weekVC?.update(forecast: forecast,
                                backgroundColor: pageColor,
                                cornerRadius: self.cornerRadius, displayOption1: displayOption1)
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
        activityIndicator.stopAnimating()
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

    private static var deviceIsIPhoneX: Bool {
        return UIDevice().userInterfaceIdiom == .phone &&
            UIScreen.main.nativeBounds.height == 2436
    }
}

extension MainViewController: LocationControllerDelegate {

    func locationController(_ locationController: LocationController, didUpdateLocation location: Location) {
        let place = Place(name: "Right Here · Right Now", region: "", placeID: "",
                          latitude: location.latitude, longitude: location.longitude)
        updateWeather(for: place)
    }

    func locationController(_ locationController: LocationController, didFailWithError error: Error) {
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
        displaySettingsAlert(title: "Location Tracking Disabled",
                             message: "This device is not tracking it's own location.\n\n"
                                + "To enable local weather forecasting, "
                                + "open this device's location settings and enable 'Location Services'.",
                             url: URL(string: "App-Prefs:root=LOCATION_SERVICES"),
                             withCancelKey: true)
    }

    private func requestUpdateApplicationSetting() {
        displaySettingsAlert(title: "Location Tracking Denied",
                             message: "Raincoat cannot access this device's location.\n\n"
                                + "To enable local weather forecasting, "
                                + "open this app's settings and set Raincoat's location access to 'Always'.",
                             url: URL(string: UIApplicationOpenSettingsURLString),
                             withCancelKey: true)
    }

    private func displayRestrictedAlert() {
        displaySettingsAlert(title: "Background Location Access Restricted",
                             message: "Sorry.  This application is not permitted to access location information on this device.",
                             url: nil,
                             withCancelKey: false)
    }

    private func displaySettingsAlert(title: String, message: String, url: URL?, withCancelKey: Bool) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)

        if withCancelKey {
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
        }

        let okAction: UIAlertAction
        if let url = url {
            okAction = UIAlertAction(title: "Open Settings", style: .default) { (_) in
                UIApplication.shared.open(url, options: [:], completionHandler: { (_) in
                    self.locationLabel.text = "Tap to try again."})
            }
        } else {
            okAction = UIAlertAction(title: "OK", style: .default)
        }
        alertController.addAction(okAction)

        self.present(alertController, animated: true, completion: nil)
    }
}
