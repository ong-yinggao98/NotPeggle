//
//  CannonBallTests.swift
//  NotPeggleTests
//
//  Created by Ying Gao on 12/2/21.
//

import XCTest
@testable import NotPeggle

class CannonBallTests: XCTestCase {

    func testConstr() {
        var test = CannonBall(angle: 0, coord: CGPoint.zero)
        var expectedVelo = CGVector(dx: 1_000, dy: 0)
        let expected = CannonBall(coord: CGPoint.zero, velocity: expectedVelo)
        XCTAssertEqual(expected, test)

        test = CannonBall(angle: CGFloat.pi / 4, coord: CGPoint.zero)
        expectedVelo = CGVector(dx: sqrt(5e5), dy: sqrt(5e5))
        let expectedCoord = CGPoint.zero
        let expectedAcceleration = CGVector(dx: 0, dy: 300)
        XCTAssertEqual(expectedCoord, test.center)
        XCTAssertEqual(expectedAcceleration, test.acceleration)
        TestUtils.compareVectors(expected: expectedVelo, actual: test.velocity)
    }

}
