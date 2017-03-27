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

    var data: [Double] {
        get {
            return storedData
        }
        set {
            storedData = newValue
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
        super.draw(rect)
        // TODO: Investigate why the comented out code exists.  Presumably to prevent too many calls to weather API.
//        guard !storedData.isEmpty else {
//                return
//        }
        guard let context = UIGraphicsGetCurrentContext() else {
                return
        }

        let border = Swift.max(rect.height, rect.width) * 0.05
        let minX = border //rect.width * 0.05
        let maxX = rect.width - border //minX
        let minY = border //rect.height * 0.05
        let maxY = rect.height - 2 * border //minY
        let barWidth = (maxX - minX) / (CGFloat(storedData.count) - 1)
        let minValue = 0.0 // storedData.min() ?? 0
        let maxValue = 1.0 // storedData.max() ?? 0

        var index: CGFloat = 0.0

        context.move(to: CGPoint(x: minX, y: maxY))
        for value in data {
            let trimmedValue = Swift.max(minValue, Swift.min(maxValue, value))
            let vHeight = (maxValue - minValue == 0.0) ? 0.0
                : 2 * minY + (maxY - minY) * CGFloat((trimmedValue - minValue) / (maxValue - minValue))
            let yValue = rect.maxY - vHeight
            //            context.move(to: CGPoint(x: minX + barWidth * index, y: maxY))
            //            context.addLine(to: CGPoint(x: minX + barWidth * (index + 1), y: maxY))
            context.addLine(to: CGPoint(x: minX + barWidth * (index), y: yValue))
            //            context.addLine(to: CGPoint(x: minX + barWidth * (index), y: yValue))
            index += 1.0
        }
        context.addLine(to: CGPoint(x: maxX, y: maxY))
        context.closePath()
        context.setFillColor(UIColor(red: 0.33, green: 0.67, blue: 1.0,
                                     alpha: 1.0 /*CGFloat(0.5 + (value - minValue) / (2 * span))*/).cgColor)
        context.fillPath()

        addBorder(context: context, minX: minX, maxX: maxX, minY: minY, maxY: maxY)
        addTicks(context: context, minX: minX, maxX: maxX, minY: minY, maxY: maxY)
        addHorizontalLines(context: context, minX: minX, maxX: maxX, minY: minY, maxY: maxY)
    }

    private func addBorder(context: CGContext, minX: CGFloat, maxX: CGFloat, minY: CGFloat, maxY: CGFloat) {
        preserveContext {
            context.move(to: CGPoint(x: minX, y: maxY))
            context.addLine(to: CGPoint(x: maxX, y: maxY))
            context.setLineWidth(0.5)
            context.setStrokeColor(UIColor.black.cgColor)
            context.strokePath()
        }
    }

    /// Adds horizontal bars to the graph ( at 1, 2 and 3 thirds up).
    ///
    /// - Parameters:
    ///   - context: The context containing the graph
    ///   - minX: Lowest x position in pixels on the graph.
    ///   - maxX: Highest x position in pixels on the graph.
    ///   - minY: Lowest y position in pixels on the graph.
    ///   - maxY: Highest y position in pixels on the graph.
    ///
    private func addHorizontalLines(context: CGContext, minX: CGFloat, maxX: CGFloat, minY: CGFloat, maxY: CGFloat) {
        preserveContext {
            let aThirdUp = (maxY - minY) / 3.0
            for i in 0...2 {
                context.move(to: CGPoint(x: minX, y: minY + aThirdUp * CGFloat(i)))
                context.addLine(to: CGPoint(x: maxX, y: minY + aThirdUp * CGFloat(i)))
            }
            let  dashes: [ CGFloat ] = [ 2.0, 2.0 ]
            context.setLineDash(phase: 0.0, lengths: dashes)
            context.setStrokeColor(UIColor.black.cgColor)
            context.strokePath()
        }
    }

    private func addTicks(context: CGContext, minX: CGFloat, maxX: CGFloat, minY: CGFloat, maxY: CGFloat) {
        preserveContext {
            let tickSpan = (maxX - minX) / 6.0
            for tickIndex in 0...6 {
                context.move(to: CGPoint(x: minX + tickSpan * CGFloat(tickIndex), y: maxY))
                context.addLine(to: CGPoint(x: minX + tickSpan * CGFloat(tickIndex), y: maxY + minY / 2.0))
            }
            context.setStrokeColor(UIColor.black.cgColor)
            context.strokePath()
        }
    }

    private func preserveContext(during action: () -> Void) {
        let currentContext = UIGraphicsGetCurrentContext()
        currentContext?.saveGState()
        action()
        currentContext?.restoreGState()
    }
}
