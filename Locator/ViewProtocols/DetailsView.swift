//
//  DetailsView.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 01/01/2018.
//  Copyright © 2018 Vincent O'Sullivan. All rights reserved.
//

protocol DetailsView {

    /// Updates the minimum temparature and time display.
    ///
    /// - Parameters:
    ///   - temperature: The temperature to be displayed.
    ///   - time: The time at which the minimum is expected.
    ///   - highlight: if `true` the the details should be highlighted.
    ///
    func minimum(temperature: String, time: String, highlight: Bool)

    /// Updates the maximum temparature and time display.
    ///
    /// - Parameters:
    ///   - temperature: The temperature to be displayed.
    ///   - time: The time at which the maximum is expected.
    ///   - highlight: if `true` the the details should be highlighted.
    ///
    func maximum(temperature: String, time: String, highlight: Bool)

    func summary(_ text: String)

    /// Updates the pressure display
    ///
    /// - Parameters:
    ///   - text: The pressure details to be displayed
    ///   - label: An identifying label (e.g. "Pressure")
    ///   - symbol: An identifying icon in the form of a `String`.
    ///
    func pressure(_ text: String, label: String, symbol: String)

    /// Updates the humidity display
    ///
    /// - Parameters:
    ///   - text: The humidity details to be displayed
    ///   - label: An identifying label (e.g. "Humidity")
    ///   - symbol: An identifying icon in the form of a `String`.
    ///
    func humidity(_ text: String, label: String, symbol: String)

    /// Updates the wind display
    ///
    /// - Parameters:
    ///   - text: The wind details to be displayed
    ///   - degrees: The (clockwise) directon from north from which the wind is coming.
    ///   - label: An identifying label (e.g. "Wind")
    ///   - symbol: An identifying icon in the form of a `String`.
    ///
    func wind(_ text: String, degrees: Double, label: String, symbol: String)
}
