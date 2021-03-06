//
//  RibbonView.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 28/12/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class RibbonView: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: 0, left: 12, bottom: 0, right: 12)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }

    override func draw(_ rect: CGRect) {

        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        context.beginPath()
        context.move(to: CGPoint(x: rect.minX, y: rect.minY))
        context.addLine(to: CGPoint(x: rect.maxY * 2.0 / 8.0, y: rect.maxY / 2.0))
        context.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.maxX - rect.maxY * 2.0 / 8.0, y: rect.maxY / 2.0))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        context.closePath()
        context.setFillColor(UIColor.copper.cgColor)

        context.fillPath()
        super.draw(rect)
    }
}
