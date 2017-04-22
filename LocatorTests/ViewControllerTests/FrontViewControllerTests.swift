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
    var testee: FrontViewController!

    // MARK: - Unit test housekeeping.

    override func setUp() {
        super.setUp()
        createTestee()
    }

    override func tearDown() {
        releaseTestee()
        super.tearDown()
    }

    private func createTestee() {
        presenter = FrontViewPresenterMock()

        let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        testee = storyboard.instantiateViewController(withIdentifier: FrontViewController.id) as? FrontViewController
    }

    private func releaseTestee() {
        testee = nil
        presenter = nil
    }

    // MARK: - Basic tests.

    func testeeNotNull() {
        XCTAssertNotNil(testee)
    }

    // MARK: - Event handling tests.

    func testeeLoadedInformsPresenter() {
        // Set up test.
        testee.presenter = presenter

        // Perform action.
        _ = testee.view

        // Assert results.
        XCTAssertTrue(presenter!.isViewCreatedInvoked)
    }
}

class FrontViewPresenterMock: FrontViewPresenter {

    public private(set) var isViewCreatedInvoked = false

    override func viewCreated() {
        isViewCreatedInvoked = true
    }
}
