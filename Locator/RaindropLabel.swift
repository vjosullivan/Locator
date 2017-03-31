//
//  RaindropLabel.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 29/03/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import UIKit

/// A UILabel shaped like a rain drop.
///
class RaindropLabel: UILabel {

    private var rainOrSnow = PrecipitationType.rain

    var precipitationType: PrecipitationType {
        get {
            return rainOrSnow
        }
        set {
            rainOrSnow = newValue
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawOutline()
    }

    private func drawOutline() {
        let radius = Swift.min(frame.width, frame.height) / 2.0
        let path: UIBezierPath = (rainOrSnow == .rain)
            ? UIBezierPath(
                roundedRect: bounds,
                byRoundingCorners: UIRectCorner.topLeft.union(.bottomLeft).union(.bottomRight),
                cornerRadii: CGSize(width: radius, height: radius))
            : UIBezierPath(roundedRect: bounds, cornerRadius: radius)

        let rainMask = CAShapeLayer()
        rainMask.frame = bounds
        rainMask.path = path.cgPath
        layer.mask = rainMask

        let frameLayer = CAShapeLayer()
        frameLayer.frame = bounds
        frameLayer.path = path.cgPath
        frameLayer.fillColor = nil
        frameLayer.borderColor = nil
        layer.addSublayer(frameLayer)
    }
}

enum PrecipitationType {
    case rain
    case snow
}
