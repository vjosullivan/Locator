//
//  FrontViewControllerTests.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 22/04/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import XCTest
@testable import Locator

class FrontViewControllerTests: XCTestCase {

    // MARK: - Constants and parameters.

    private let storyBoardName = "Main"

    // MARK: - Object under test.

    var presenter: FrontViewPresenterMock!
    var frontVC: FrontViewController!
    var forecast: DarkSkyForecast!

    // MARK: - Unit test housekeeping.

    override func setUp() {
        super.setUp()
        presenter = FrontViewPresenterMock(forecast: createForecast())

        let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        frontVC = storyboard.instantiateViewController(withIdentifier: FrontViewController.id) as? FrontViewController
    }

    override func tearDown() {
        frontVC = nil
        presenter = nil
        super.tearDown()
    }

    private func createForecast() -> DarkSkyForecast {
        let json = ["latitude": 51.3, "longitude": -1.0, "timezone": "Europe/London", "flags": ["units": "uk2"]] as [String : AnyObject]
        let forecast = DarkSkyForecast(dictionary: json)
        return forecast!
    }

    // MARK: - Basic tests.

    func testNotNull() {
        XCTAssertNotNil(frontVC)
    }

    // MARK: - Event handling tests.

    func testFrontVCLoadedInformsPresenter() {
        // Set up test.
        frontVC.presenter = presenter

        // Perform action.
        _ = frontVC.view
        frontVC.viewDidLayoutSubviews()

        // Assert results.
        XCTAssertTrue(presenter!.isViewCreatedInvoked)
    }
}

class FrontViewPresenterMock: FrontViewPresenter {

    public private(set) var isViewCreatedInvoked = false

    override func viewCreated(view: FrontView) {
        isViewCreatedInvoked = true
    }
}
