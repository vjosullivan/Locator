//
//  DetailsViewController.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 29/12/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    // MARK: - Local constants and variables

    private var presenter: DetailsPresenter?

    // MARK: - Outlets.

    @IBOutlet weak var minTempValue: UILabel!
    @IBOutlet weak var minTempTime: UILabel!
    @IBOutlet weak var maxTempValue: UILabel!
    @IBOutlet weak var maxTempTime: UILabel!

    @IBOutlet weak var pressureSymbol: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var pressureText: UILabel!

    @IBOutlet weak var windSymbol: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var windText: UILabel!
    @IBOutlet weak var windSubtext: UILabel!

    @IBOutlet weak var humiditySymbol: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var humidityText: UILabel!

    @IBOutlet weak var returnButton: UIButton!

    @IBOutlet weak var detailsLabel: UILabel!

    // MARK: - View Controller functions.

    override func viewDidLoad() {
        super.viewDidLoad()

        // Nothing to do here because
        // everything is handled by the presenter
        // after the subviews have been laid out.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        presenter?.viewCreated(view: self)
    }

    // MARK: - Public functions.

    func configure(presenter: DetailsPresenter, backgroundColor: UIColor, cornerRadius: CGFloat) {
        self.presenter = presenter

        setColors(to: backgroundColor)
        view.topCornerRadius = cornerRadius
    }

    // MARK: - Private functions.

    /// Sets the view's colours.
    ///
    /// - Parameter backgroundColor: The new colour.
    ///
    private func setColors(to backgroundColor: UIColor) {
        let foregroundColor = backgroundColor.darker
        minTempValue.textColor = foregroundColor
        minTempTime.textColor = foregroundColor
        maxTempValue.textColor = foregroundColor
        maxTempTime.textColor = foregroundColor

        pressureSymbol.textColor = foregroundColor
        pressureLabel.textColor = foregroundColor
        pressureText.textColor = foregroundColor

        windSymbol.textColor = foregroundColor
        windLabel.textColor = foregroundColor
        windText.textColor = foregroundColor
        windSubtext.textColor = foregroundColor

        humiditySymbol.textColor = foregroundColor
        humidityLabel.textColor = foregroundColor
        humidityText.textColor = foregroundColor
        detailsLabel.textColor = foregroundColor

        returnButton.setTitleColor(foregroundColor, for: .normal)
        view.backgroundColor = backgroundColor
    }
}

extension DetailsViewController: DetailsView {

    func minimum(temperature: String, time: String, highlight: Bool) {
        setTemperature(temperatureField: minTempValue, timeField: minTempTime, temperature: temperature, time: time, highlight: highlight)
    }

    func maximum(temperature: String, time: String, highlight: Bool) {
        setTemperature(temperatureField: maxTempValue, timeField: maxTempTime, temperature: temperature, time: time, highlight: highlight)
    }

    func summary(_ text: String) {
        detailsLabel.text = text
    }

    func pressure(_ text: String, label: String, symbol: String) {
        self.pressureText.text = text
        self.pressureLabel.text = label
        self.pressureSymbol.text = symbol
    }

    func humidity(_ text: String, label: String, symbol: String) {
        self.humidityText.text = text
        self.humidityLabel.text = label
        self.humiditySymbol.text = symbol
    }

    func wind(_ text: String, degrees: Double, label: String, symbol: String) {
        self.windText.text = text
        self.windLabel.text = label
        self.windSymbol.text = symbol

        // Add 90° clockwise because the icon currently used points east (90°)
        // when the direction value is zero (north).
        let angle = CGFloat(degrees + 90.0) * CGFloat.pi / 180.0
        windSymbol.transform = CGAffineTransform.init(rotationAngle: angle)
    }

    private func setTemperature(temperatureField tempField: UILabel, timeField: UILabel, temperature: String, time: String, highlight: Bool) {
        tempField.text = temperature
        timeField.text = time
        if highlight {
            tempField.textColor = .amber
            timeField.textColor = .amber
        }
    }
}
