//
//  GraphView.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 22/01/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class GraphView: UIView {

    private var storedData = [Double]()
    private var invert = true

    var invertGraph: Bool {
        get {
            return invert
        }
        set {
            invert = newValue
            print("\n\ninverted\n\n")
        }
    }
    var data: [Double] {
        get {
            return storedData
        }
        set {
            storedData = newValue
            print("wahey! \(storedData.count)")
            setNeedsDisplay()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {
        print("Drawing....")
        guard let context = UIGraphicsGetCurrentContext(),
            !storedData.isEmpty else {
                print("Not really drawing....")
                return
        }
        print("Really drawing....")

        let barWidth = frame.width / CGFloat(storedData.count)
        let yBase = invert ? frame.height : 0
        let minValue = 0.0 // storedData.min() ?? 0
        let maxValue = 0.0 // storedData.max() ?? 0
        let span = maxValue - minValue

        var index: CGFloat = 0.0

        //        context.move(to: CGPoint(x: 0.0, y: 0.0))
        //        context.addLine(to: CGPoint(x: 0.0, y: rect.maxY))
        //        context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        //        context.addLine(to: CGPoint(x: rect.maxX, y: 0.0))
        //        context.closePath()
        //        context.setFillColor(UIColor(red: 0.5, green: 1.0, blue: 1.0, alpha: 1.0).cgColor)
        //        context.fillPath()
        //        super.draw(rect)
        for value in data {
            let trimmedValue = Swift.max(minValue, Swift.min(maxValue, value))
            let vHeight = (maxValue - minValue == 0.0) ? 0.0
                : (rect.maxY - rect.minY) * CGFloat((trimmedValue - minValue) / (maxValue - minValue))
            print(invert, value, vHeight)
            let yValue = invert ? rect.maxY - vHeight : rect.minY + vHeight
            context.move(to: CGPoint(x: barWidth * index, y: yBase))
            context.addLine(to: CGPoint(x: barWidth * (index + 1), y: yBase))
            context.addLine(to: CGPoint(x: barWidth * (index + 1), y: yValue))
            context.addLine(to: CGPoint(x: barWidth * (index), y: yValue))
            context.closePath()
            context.setFillColor(UIColor(red: 0.25, green: 0.50, blue: 1.0,
                                         alpha: CGFloat(0.5 + (value - minValue) / (2 * span))).cgColor)
            context.fillPath()
            super.draw(rect)
            index += 1.0
        }
    }
}
