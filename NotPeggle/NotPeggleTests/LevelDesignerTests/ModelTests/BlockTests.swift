//
//  Rect2DTests.swift
//  NotPeggleTests
//
//  Created by Ying Gao on 25/2/21.
//

import XCTest
@testable import NotPeggle

class BlockTests: XCTestCase {

    func testMid() {
        let rect = Block(
            origin: Point(xCoord: 0, yCoord: 0),
            width: 2,
            height: 4,
            angle: Double.pi/2
        )
        let expected = Point(xCoord: -2, yCoord: 1)
        let actual = rect.mid
        checkPointsWithError(expected: expected, actual: actual)
    }

    private func checkPointsWithError(expected: Point, actual: Point) {
        XCTAssertEqual(expected.xCoord, actual.xCoord, accuracy: 1e-5)
        XCTAssertEqual(expected.yCoord, actual.yCoord, accuracy: 1e-5)
    }

}
