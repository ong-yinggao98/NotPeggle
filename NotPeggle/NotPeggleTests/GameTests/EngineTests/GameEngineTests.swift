//
//  EngineTests.swift
//  NotPeggleTests
//
//  Created by Ying Gao on 14/2/21.
//

import XCTest
@testable import NotPeggle

class GameEngineTests: XCTestCase {

    var testCase: GameEngine {
        let frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        return GameEngine(frame: frame)
    }

    func testLoadPegs_emptyArray_noChange() {
        let engine = testCase
        engine.loadPegsIntoWorld(pegs: [])
        XCTAssertTrue(engine.gamePegs.isEmpty)
    }

    var radius: CGFloat {
        return CGFloat(Constants.pegRadius)
    }

    var pegA: GamePeg {
        return GamePeg(pegColor: .blue, pos: CGPoint(x: 40, y: 40), radius: radius)!
    }

    var pegB: GamePeg {
        return GamePeg(pegColor: .orange, pos: CGPoint(x: 100, y: 100), radius: radius)!
    }

    var pegC: GamePeg {
        return GamePeg(pegColor: .blue, pos: CGPoint(x: 210, y: 80), radius: radius)!
    }

    func testLoadPegs_pegsAdded() {
        let engine = testCase
        engine.loadPegsIntoWorld(pegs: [pegA, pegB])
        XCTAssertTrue(engine.gamePegs.contains(pegA))
        XCTAssertTrue(engine.gamePegs.contains(pegB))
    }

    func testLoadPegs_duplicatePegs_extrasNotAdded() {
        let engine = testCase
        engine.loadPegsIntoWorld(pegs: [pegA, pegB])
        engine.loadPegsIntoWorld(pegs: [pegA])
        XCTAssertEqual(engine.gamePegs.count, 2)
    }

    func testLaunch_topLeft() {
        var target = CGPoint(x: 0, y: 0)
        let engine = testCase
        engine.launch(towards: target)
        guard let cannon = engine.cannon else {
            XCTFail("Cannon should be fired")
            return
        }
        let velocity = cannon.velocity
        let expectedVelocity = CGVector(dx: -986.39392, dy: -164.39899)
        TestUtils.compareVectors(expected: expectedVelocity, actual: velocity)

        target = CGPoint(x: 150, y: 150)
        engine.launch(towards: target)
        XCTAssertEqual(engine.cannon, cannon, "New cannon should not be created")
    }

    func testLaunch_topRight() {
        let target = CGPoint(x: 300, y: 0)
        let engine = testCase
        engine.launch(towards: target)
        guard let velocity = engine.cannon?.velocity else {
            XCTFail("Cannon should be fired")
            return
        }
        let expectedVelocity = CGVector(dx: 986.39392, dy: -164.39899)
        TestUtils.compareVectors(expected: expectedVelocity, actual: velocity)
    }

    func testLaunch_bottomLeft() {
        let target = CGPoint(x: 0, y: 300)
        let engine = testCase
        engine.launch(towards: target)
        guard let velocity = engine.cannon?.velocity else {
            XCTFail("Cannon should be fired")
            return
        }
        let expectedVelocity = CGVector(dx: -478.85213, dy: 877.89557)
        TestUtils.compareVectors(expected: expectedVelocity, actual: velocity)
    }

    func testLaunch_bottomRight() {
        var target = CGPoint(x: 300, y: 300)
        let engine = testCase
        engine.launch(towards: target)
        guard let velocity = engine.cannon?.velocity else {
            XCTFail("Cannon should be fired")
            return
        }
        var expectedVelocity = CGVector(dx: 478.85213, dy: 877.89557)
        TestUtils.compareVectors(expected: expectedVelocity, actual: velocity)

        engine.removeCannonBall()
        XCTAssertNil(engine.cannon)

        // testing relaunch
        target = CGPoint(x: 0, y: 300)
        engine.launch(towards: target)
        guard let newVelocity = engine.cannon?.velocity else {
            XCTFail("Cannon should be fired")
            return
        }
        expectedVelocity = CGVector(dx: -478.85213, dy: 877.89557)
        TestUtils.compareVectors(expected: expectedVelocity, actual: newVelocity)
    }

    func testRemoveAllHitPegs() {
        let engine = testCase
        let hitPegB = pegB
        hitPegB.hit = true
        engine.loadPegsIntoWorld(pegs: [pegA, hitPegB])
        engine.removeAllHitPegs()
        XCTAssertEqual(engine.gamePegs, [pegA])
    }

}
