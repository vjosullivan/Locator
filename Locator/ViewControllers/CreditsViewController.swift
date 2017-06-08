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

        screenTitle.text = "Credits"
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
        let myString = "RAINCOAT\n\nDesigned and developed by\nVincent O'Sullivan\n·\n"
            + "Powered by\nDark Sky\n·\n"
            + "Original Artwork\nBeth Rose\n·\n"
            + "Weather Symbols\nWeather Awesome\n·\n"
            + "Font (Nevis)\ntenbytwenty"

        let titleAttributes = [
            UIFontDescriptorFamilyAttribute: "Nevis",
            UIFontWeightTrait : UIFontWeightHeavy] as [String : Any]
        let subTitleAttributes = [
            UIFontDescriptorFamilyAttribute: "Nevis",
            UIFontWeightTrait : UIFontWeightThin] as [String : Any]
        let nameAttributes = [
            UIFontDescriptorFamilyAttribute: "Nevis",
            UIFontWeightTrait : UIFontWeightHeavy] as [String : Any]

        let titleFont = UIFont(descriptor: UIFontDescriptor(fontAttributes: titleAttributes), size: 18.0)
        let subTitleFont = UIFont(descriptor: UIFontDescriptor(fontAttributes: subTitleAttributes), size: 13.5)
        let nameFont = UIFont(descriptor: UIFontDescriptor(fontAttributes: nameAttributes), size: 18.0)

        let myMutableString = NSMutableAttributedString(
            string: myString,
            attributes: [NSFontAttributeName: subTitleFont, NSForegroundColorAttributeName: textColor])

        myMutableString.addAttribute(NSFontAttributeName,
                                     value: titleFont,
                                     range: NSRange(location: 0, length: 8))
        myMutableString.addAttribute(NSFontAttributeName,
                                     value: nameFont,
                                     range: NSRange(location: 36, length: 18))
        myMutableString.addAttribute(NSFontAttributeName,
                                     value: nameFont,
                                     range: NSRange(location: 68, length: 9))
        myMutableString.addAttribute(NSFontAttributeName,
                                     value: nameFont,
                                     range: NSRange(location: 96, length: 9))
        myMutableString.addAttribute(NSFontAttributeName,
                                     value: nameFont,
                                     range: NSRange(location: 124, length: 15))
        myMutableString.addAttribute(NSFontAttributeName,
                                     value: nameFont,
                                     range: NSRange(location: 155, length: 3))
        myMutableString.addAttribute(NSFontAttributeName,
                                     value: nameFont,
                                     range: NSRange(location: 160, length: 6))
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
