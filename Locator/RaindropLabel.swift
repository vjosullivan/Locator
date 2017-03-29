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

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawRaindropShape()
    }

    private func drawRaindropShape() {
        let width = Swift.min(frame.width, frame.height) / 2.0
        let rainShapedPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: UIRectCorner.topLeft.union(.bottomLeft).union(.bottomRight),
            cornerRadii: CGSize(width: width, height: width)
        )

        let rainMask = CAShapeLayer()
        rainMask.frame = bounds
        rainMask.path = rainShapedPath.cgPath
        layer.mask = rainMask

        let frameLayer = CAShapeLayer()
        frameLayer.frame = bounds
        frameLayer.path = rainShapedPath.cgPath
        frameLayer.fillColor = nil
        frameLayer.borderColor = nil
        layer.addSublayer(frameLayer)
    }
}
