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

    //let presenter: FrontViewPresenterMock
    var testee: FrontViewController!

    override func setUp() {
        super.setUp()
        createTestee()
    }

    override func tearDown() {
        releaseTestee()
        super.tearDown()
    }

    private func createTestee() {
        testee = FrontViewController()
    }

    private func releaseTestee() {
        testee = nil
    }

    func testNotNull() {
        XCTAssertNotNil(testee)
    }
}

//class FrontViewPresenterMock: FrontViewPresenter {
//
//}
