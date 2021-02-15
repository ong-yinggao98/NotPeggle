//
//  GravBouncingBallTests.swift
//  NotPeggleTests
//
//  Created by Ying Gao on 11/2/21.
//

import XCTest
@testable import NotPeggle

class GravBouncingBallTests: XCTestCase {

    func testConstr() {
        let center = CGPoint.zero
        let invalidRadius = CGFloat(0)
        let velocity = CGVector(dx: 4, dy: 0)
        XCTAssertNil(GravBouncingBall(center: center, radius: invalidRadius, velocity: velocity))
        XCTAssertNotNil(GravBouncingBall(center: center, radius: 1, velocity: velocity))
    }

}
