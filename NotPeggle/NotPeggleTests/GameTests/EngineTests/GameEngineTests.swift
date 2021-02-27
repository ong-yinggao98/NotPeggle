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
        return GameEngine(frame: frame, delegate: nil)
    }

    func testLoadPegs_emptyArray_noChange() {
        let engine = testCase
        engine.loadIntoWorld(pegs: [], blocks: [])
        XCTAssertTrue(engine.gamePegs.isEmpty)
    }

    var radius: CGFloat {
        CGFloat(Constants.pegRadius)
    }

    var pegA: GamePeg! {
        GamePeg(pegColor: .blue, pos: CGPoint(x: 40, y: 40), radius: radius)
    }

    var pegB: GamePeg! {
        GamePeg(pegColor: .orange, pos: CGPoint(x: 100, y: 100), radius: radius)
    }

    var pegC: GamePeg! {
        GamePeg(pegColor: .blue, pos: CGPoint(x: 210, y: 80), radius: radius)
    }

    func testLoadPegs_pegsAdded() {
        let engine = testCase
        engine.loadIntoWorld(pegs: [pegA, pegB], blocks: [])
        XCTAssertTrue(engine.gamePegs.contains(pegA))
        XCTAssertTrue(engine.gamePegs.contains(pegB))
    }

    func testLoadPegs_duplicatePegs_extrasNotAdded() {
        let engine = testCase
        engine.loadIntoWorld(pegs: [pegA, pegB], blocks: [])
        engine.loadIntoWorld(pegs: [pegA], blocks: [])
        XCTAssertEqual(engine.gamePegs.count, 2)
    }

    func testAim() {
        let engine = testCase
        XCTAssertEqual(engine.launchAngle, CGFloat.pi / 2)

        var target = CGPoint(x: 0, y: 0)
        engine.aim(at: target)
        var expectedAngle: CGFloat = atan(25 / 150) + CGFloat.pi
        XCTAssertEqual(engine.launchAngle, expectedAngle)

        target = CGPoint(x: 300, y: 0)
        engine.aim(at: target)
        expectedAngle = atan(25 / -150)
        XCTAssertEqual(engine.launchAngle, expectedAngle)

        target = CGPoint(x: 0, y: 300)
        engine.aim(at: target)
        expectedAngle = atan(275 / -150) + CGFloat.pi
        XCTAssertEqual(engine.launchAngle, expectedAngle)

        target = CGPoint(x: 300, y: 300)
        engine.aim(at: target)
        expectedAngle = atan(275 / 150)
        XCTAssertEqual(engine.launchAngle, expectedAngle)
    }

    func testLaunch_topLeft() {
        var target = CGPoint(x: 0, y: 0)
        let engine = testCase
        engine.aim(at: target)
        engine.launch()
        guard let cannon = engine.cannon else {
            XCTFail("Cannon should be fired")
            return
        }
        let velocity = cannon.velocity
        let expectedVelocity = CGVector(dx: -986.393_92, dy: -164.398_99)
        TestUtils.compareVectors(expected: expectedVelocity, actual: velocity)

        target = CGPoint(x: 150, y: 150)
        engine.aim(at: target)
        engine.launch()
        XCTAssertEqual(engine.cannon, cannon, "New cannon should not be created")
    }

    func testLaunch_topRight() {
        let target = CGPoint(x: 300, y: 0)
        let engine = testCase
        engine.aim(at: target)
        engine.launch()
        guard let velocity = engine.cannon?.velocity else {
            XCTFail("Cannon should be fired")
            return
        }
        let expectedVelocity = CGVector(dx: 986.393_92, dy: -164.398_99)
        TestUtils.compareVectors(expected: expectedVelocity, actual: velocity)
    }

    func testLaunch_bottomLeft() {
        let target = CGPoint(x: 0, y: 300)
        let engine = testCase
        engine.aim(at: target)
        engine.launch()
        guard let velocity = engine.cannon?.velocity else {
            XCTFail("Cannon should be fired")
            return
        }
        let expectedVelocity = CGVector(dx: -478.852_13, dy: 877.895_57)
        TestUtils.compareVectors(expected: expectedVelocity, actual: velocity)
    }

    func testLaunch_bottomRight() {
        var target = CGPoint(x: 300, y: 300)
        let engine = testCase
        engine.aim(at: target)
        engine.launch()
        guard let velocity = engine.cannon?.velocity else {
            XCTFail("Cannon should be fired")
            return
        }
        var expectedVelocity = CGVector(dx: 478.852_13, dy: 877.895_57)
        TestUtils.compareVectors(expected: expectedVelocity, actual: velocity)

        engine.removeCannonBall()
        XCTAssertNil(engine.cannon)

        // testing relaunch
        target = CGPoint(x: 0, y: 300)
        engine.aim(at: target)
        engine.launch()
        guard let newVelocity = engine.cannon?.velocity else {
            XCTFail("Cannon should be fired")
            return
        }
        expectedVelocity = CGVector(dx: -478.852_13, dy: 877.895_57)
        TestUtils.compareVectors(expected: expectedVelocity, actual: newVelocity)
    }

    func testRemoveAllHitPegs() {
        let engine = testCase
        guard let hitPegB = pegB else {
            XCTFail("Why do I even need to unwrap an implicitly unwrapped optional??")
            return
        }
        hitPegB.hit = true
        engine.loadIntoWorld(pegs: [pegA, hitPegB], blocks: [])
        engine.removeAllHitPegs()
        XCTAssertEqual(engine.gamePegs, [pegA])
    }

}
