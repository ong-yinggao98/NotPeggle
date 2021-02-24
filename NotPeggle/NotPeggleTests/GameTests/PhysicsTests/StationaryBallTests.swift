//
//  StationaryObjectTests.swift
//  NotPeggleTests
//
//  Created by Ying Gao on 11/2/21.
//

import XCTest
@testable import NotPeggle

class StationaryBallTests: XCTestCase {

    func testConstr() {
        let point = CGPoint(x: 30, y: 30)
        let invalidRadius = CGFloat(0)
        XCTAssertNil(StationaryBall(center: point, radius: invalidRadius))

        XCTAssertNotNil(StationaryBall(center: point, radius: 1))
    }

    var collider: PhysicsBall? {
        let center = CGPoint(x: 30, y: 30)
        let velocity = CGVector(dx: 4, dy: 0)
        return PhysicsBall(pos: center, radius: 30, restitution: 0.8, velo: velocity, accel: CGVector.zero)
    }

    var collidee: StationaryBall? {
        let center = CGPoint(x: 60, y: 30)
        return StationaryBall(center: center, radius: 30)
    }

    func testNoBounce() {
        guard
            let collider = collider,
            let test = collidee
        else {
            XCTFail("init should not fail")
            return
        }
        test.handleCollision(object: collider)
        XCTAssertEqual(test, collidee)
        TestUtils.compareVectors(expected: CGVector.zero, actual: CGVector.zero)
    }

}
