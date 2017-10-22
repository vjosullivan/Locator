//
//  SolarViewController.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 29/12/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class SolarViewController: UIViewController {

    @IBOutlet weak var returnButton: UIButton!

    @IBOutlet weak var sunriseSymbol: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunriseTimeThere: UILabel!
    @IBOutlet weak var sunriseTimeHere: UILabel!

    @IBOutlet weak var sunsetSymbol: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var sunsetTimeThere: UILabel!
    @IBOutlet weak var sunsetTimeHere: UILabel!

    @IBOutlet weak var nextSunriseLabel: UILabel!

    @IBOutlet weak var moonSymbol: UILabel!
    @IBOutlet weak var moonBackground: UILabel!
    @IBOutlet weak var moonName: UILabel!

    var backgroundColor: UIColor? {
        didSet {
            updateColors()
            updateTextColors()
        }
    }
    var viewModel: SolarViewRepresentable? {
        didSet {
            updateView()
            updateTextColors()
        }
    }
    var cornerRadius: CGFloat? {
        didSet {
            view.topCornerRadius = cornerRadius ?? 8
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    fileprivate func updateTextColors() {
        guard let textColor = backgroundColor?.darker, let viewModel = viewModel else { return }

        sunriseSymbol.textColor = viewModel.sunHasRisenToday ? .amber : textColor
        sunsetSymbol.textColor  = viewModel.sunHasSetToday ? .amber : textColor
    }

    fileprivate func updateView() {
        guard let viewModel = viewModel else { return }

        sunriseTimeThere.text = viewModel.sunriseTimeAtLocation
        sunriseTimeHere.text  = (viewModel.sunriseTimeAtDevice.isEmpty) ? " " : viewModel.sunriseTimeAtDevice
        sunriseSymbol.text    = viewModel.sunriseIcon

        sunsetTimeThere.text = viewModel.sunsetTimeAtLocation
        sunsetTimeHere.text  = (viewModel.sunsetTimeAtDevice.isEmpty) ? " " : viewModel.sunsetTimeAtDevice
        sunsetSymbol.text    = viewModel.sunsetIcon

        nextSunriseLabel.text = viewModel.timeToSunRiseOrSet

        if viewModel.moonPhaseIcon.isEmpty {
            moonSymbol.text     = ""
            moonBackground.text = ""
            moonName.text       = ""
        } else {
            moonSymbol.text = viewModel.moonPhaseIcon
            moonBackground.text  = Weather.newMoonAlt.symbol
            moonName.text   = viewModel.moonPhaseText
        }
    }

    fileprivate func updateColors() {
        guard let textColor = backgroundColor?.darker else { return }

        sunriseLabel.textColor     = textColor
        sunriseTimeThere.textColor = textColor
        sunriseTimeHere.textColor  = textColor
        sunsetLabel.textColor     = textColor
        sunsetTimeThere.textColor = textColor
        sunsetTimeHere.textColor  = textColor
        nextSunriseLabel.textColor = textColor

        moonSymbol.textColor = UIColor(white: 1.0, alpha: 0.9)
        moonBackground.textColor = UIColor(white: 0.8, alpha: 0.5)
        moonName.textColor = textColor

        returnButton.setTitleColor(textColor, for: .normal)
        view.backgroundColor = backgroundColor
    }
}
