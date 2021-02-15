//
//  GamePegTests.swift
//  NotPeggleTests
//
//  Created by Ying Gao on 12/2/21.
//

import XCTest
@testable import NotPeggle

class GamePegTests: XCTestCase {

    var peg: GamePeg? {
        return GamePeg(pegColor: .blue, pos: CGPoint(x: 50, y: 80))
    }

    func testCollision() {
        let cannonBall = CannonBall(angle: 0, coord: CGPoint(x: 114, y: 80))
        let distCannon = CannonBall(angle: 0, coord: CGPoint(x: 50, y: 200))
        guard let peg = peg else {
            XCTFail("Init should not fail")
            return
        }
        XCTAssertFalse(peg.hit)
        peg.handleCollision(object: distCannon)
        XCTAssertFalse(peg.hit)
        peg.handleCollision(object: cannonBall)
        XCTAssertTrue(peg.hit)
        peg.handleCollision(object: distCannon)
        XCTAssertTrue(peg.hit)
    }

}
