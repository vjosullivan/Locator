//
//  CreditsViewController.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 23/01/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class CreditsViewController: UIViewController {

    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var returnButton: UIButton!

    @IBOutlet weak var rollCreditsButton: UIButton!
    @IBOutlet weak var creditsScrollView: UIScrollView!
    @IBOutlet weak var credits: UILabel!
    @IBOutlet weak var darkSkyButton: UIButton!

    let hMaskLayer = CAGradientLayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        creditsScrollView.contentOffset = CGPoint.zero
        credits.attributedText = creditsText(textColor: UIColor.clear)
    }

    override func viewDidLayoutSubviews() {
        //applyEdgeFading(color: UIColor.clear)
        fadeInCredits()
    }

    @IBAction func linkToDarkSky(_ sender: UIButton) {
        if let url = URL(string: "https://darksky.net/poweredby/") {
            UIApplication.shared.open(url, options: [:])
        }
    }

    @IBAction func rollCredits() {
        loopCredits()
    }

    func update(forecast: DarkSkyForecast, backgroundColor: UIColor, cornerRadius: CGFloat) {
        let foregroundColor = backgroundColor.darker

        screenTitle.text = "Raincoat"
        screenTitle.textColor = foregroundColor
        darkSkyButton.setTitleColor(foregroundColor, for: .normal)
        credits.attributedText = creditsText(textColor: foregroundColor)

        returnButton.setTitleColor(foregroundColor, for: .normal)
        rollCreditsButton.setTitleColor(foregroundColor, for: .normal)
        applyEdgeFading(color: backgroundColor)
        view.backgroundColor = backgroundColor
        view.bottomCornerRadius = cornerRadius
    }

    private func creditsText(textColor: UIColor) -> NSAttributedString {
        let myString = "\n\nDesigned and developed by\nVincent O'Sullivan\n\n·\n\n"
            + "Original Artwork\nBethany Rose\n\n·\n\n"
            + "Powered by\nDark Sky\n\n·\n\n"
            + "Weather Symbols\nWeather Awesome\n\n·\n\n"
            + "Font (Nevis)\ntenbytwenty"

        let subTitleDescriptor = UIFontDescriptor(
            fontAttributes: [UIFontDescriptor.AttributeName.family: "Nevis",
                             UIFontDescriptor.AttributeName.traits: [UIFontDescriptor.TraitKey.weight : UIFont.Weight.thin]])

        let nameDescriptor = UIFontDescriptor(
            fontAttributes: [UIFontDescriptor.AttributeName.family: "Nevis",
                             UIFontDescriptor.AttributeName.traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.heavy]])

        let subTitleFont = UIFont(descriptor: subTitleDescriptor, size: 13.5)
        let nameFont = UIFont(descriptor: nameDescriptor, size: 20.0)

        let myMutableString = NSMutableAttributedString(
            string: myString,
            attributes: [NSAttributedStringKey.font: subTitleFont, NSAttributedStringKey.foregroundColor: textColor])

        myMutableString.addAttribute(NSAttributedStringKey.font, value: nameFont,
                                     range: NSRange(location: 28, length: 18))
        myMutableString.addAttribute(NSAttributedStringKey.font,
                                     value: nameFont,
                                     range: NSRange(location: 68, length: 12))
        myMutableString.addAttribute(NSAttributedStringKey.font,
                                     value: nameFont,
                                     range: NSRange(location: 96, length: 8))
        myMutableString.addAttribute(NSAttributedStringKey.font,
                                     value: nameFont,
                                     range: NSRange(location: 125, length: 15))
        myMutableString.addAttribute(NSAttributedStringKey.font,
                                     value: nameFont,
                                     range: NSRange(location: 158, length: 3))
        myMutableString.addAttribute(NSAttributedStringKey.font,
                                     value: nameFont,
                                     range: NSRange(location: 163, length: 6))
        //Add more attributes here
        return myMutableString
    }

    private func applyEdgeFading(color: UIColor) {

        let innerColor = color.withAlphaComponent(0.0).cgColor
        let outerColor = color.withAlphaComponent(1.0).cgColor

        // first, define a horizontal gradient (left/right edges)
        hMaskLayer.opacity = 0.9
        hMaskLayer.colors = [outerColor, innerColor, innerColor, outerColor]
        hMaskLayer.locations = [NSNumber(value: 0.0), NSNumber(value: 0.05), NSNumber(value: 0.85), NSNumber(value: 1.0)]
        hMaskLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        hMaskLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        let maskFrame = CGRect(x: creditsScrollView.frame.origin.x,
                               y: creditsScrollView.frame.origin.y,
                               width: creditsScrollView.frame.size.width,
                               height: creditsScrollView.frame.size.height)
        hMaskLayer.frame = maskFrame

        // The mask must be added to the root view, not the scrollView,
        // otherwise it will move as the user scrolls!
        view.layer.addSublayer(hMaskLayer)
    }

    private func loopCredits() {
        self.rollCreditsButton.isEnabled = false
        let frame = creditsScrollView.frame
        let finalOffset = CGPoint(x: 0.0, y: -(creditsScrollView.intrinsicContentSize.height - frame.size.height) * 1.5)
        self.creditsScrollView.contentOffset = CGPoint.zero

        UIView.animate(withDuration: 9.0, delay: 0.0, options: .curveEaseIn, animations: {
            self.creditsScrollView.contentOffset = finalOffset
        }, completion: { (_) in
            self.fadeInCredits()
        })
    }

    private func fadeInCredits() {
        self.credits.alpha = 0.0
        self.creditsScrollView.contentOffset = CGPoint.zero
        UIView.animate(withDuration: 2.0, delay: 0.75, options: .curveEaseOut, animations: {
            self.credits.alpha = 1.0
        }, completion: { (_) in
            self.rollCreditsButton.isEnabled = true
        })
    }
}
