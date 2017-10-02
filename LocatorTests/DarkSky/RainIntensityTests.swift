//
//  RainIntensityTests.swift
//  Locator
//
//  Created by Vincent O'Sullivan on 26/01/2017.
//  Copyright © 2017 Vincent O'Sullivan. All rights reserved.
//

import XCTest
@testable import Locator

class RainIntensityTests: XCTestCase {

    func testValues() {
        let data = [
            0.0, 0.5,
            1.0, 2.0, 3.0, 4.0, 5.0,
            6.0, 7.0, 8.0, 9.0, 10.0,
            11.0, 12.0, 13.0, 14.0, 15.0,
            16.0, 17.0, 18.0, 19.0, 20.0]
        let output = RainIntensity(data: data).factorised()
        XCTAssertEqual(0.0, output[0], accuracy: 0.005)
        XCTAssertEqual(0.1667, output[1], accuracy: 0.005)

        XCTAssertEqual(0.3333, output[2], accuracy: 0.005)
        XCTAssertEqual(0.3809, output[3], accuracy: 0.005)
        XCTAssertEqual(0.4285, output[4], accuracy: 0.005)
        XCTAssertEqual(0.4761, output[5], accuracy: 0.005)
        XCTAssertEqual(0.5238, output[6], accuracy: 0.005)

        XCTAssertEqual(0.5714, output[7], accuracy: 0.005)
        XCTAssertEqual(0.6190, output[8], accuracy: 0.005)
        XCTAssertEqual(0.6666, output[9], accuracy: 0.005)
      //XCTAssertEqual(0.0, output[10], accuracy: 0.005)
        XCTAssertEqual(0.7499, output[11], accuracy: 0.005)

      //XCTAssertEqual(0.0, output[12], accuracy: 0.005)
      //XCTAssertEqual(0.0, output[13], accuracy: 0.005)
      //XCTAssertEqual(0.0, output[14], accuracy: 0.005)
      //XCTAssertEqual(0.0, output[15], accuracy: 0.005)
        XCTAssertEqual(0.9584, output[16], accuracy: 0.005)

        XCTAssertEqual(1.0000, output[17], accuracy: 0.005)
      //XCTAssertEqual(1.0, output[18], accuracy: 0.005)
      //XCTAssertEqual(1.0, output[19], accuracy: 0.005)
      //XCTAssertEqual(1.0, output[20], accuracy: 0.005)
        XCTAssertEqual(1.0000, output[21], accuracy: 0.005)
    }
}
