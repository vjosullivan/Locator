//
//  UIView_extension.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 05/04/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import UIKit

extension UIView {

    var bottomCornerRadius: CGFloat {
        get {
            return 0.0
        }
        set {
            roundCorners(radius: newValue, corners: UIRectCorner.bottomLeft.union(.bottomRight))
        }
    }

    var topCornerRadius: CGFloat {
        get {
            return 0.0
        }
        set {
            roundCorners(radius: newValue, corners: UIRectCorner.topLeft.union(.topRight))
        }
    }

    var cornerRadius: CGFloat {
        get {
            return 0.0
        }
        set {
            roundCorners(radius: newValue, corners: UIRectCorner.allCorners)
        }
    }

    private func roundCorners(radius: CGFloat, corners: UIRectCorner) {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius))

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
