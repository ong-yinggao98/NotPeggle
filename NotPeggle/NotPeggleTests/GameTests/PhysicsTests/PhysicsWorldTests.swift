//
//  PhysicsWorldTests.swift
//  NotPeggleTests
//
//  Created by Ying Gao on 12/2/21.
//

import XCTest
@testable import NotPeggle

class PhysicsWorldTests: XCTestCase {

    var frame = CGRect(x: 0, y: 0, width: 300, height: 300)

    var bodyA: PhysicsBall? {
        return PhysicsBall(
            pos: CGPoint(x: 150, y: 30),
            radius: 30,
            restitution: 0,
            velo: CGVector.zero,
            accel: CGVector.zero
        )
    }

    var bodyB: PhysicsBall? {
        return PhysicsBall(
            pos: CGPoint(x: 70, y: 90),
            radius: 30,
            restitution: 0.8,
            velo: CGVector(dx: 1, dy: 0),
            accel: CGVector(dx: 0, dy: 9.81)
        )
    }

    func testInsert() {
        let test = PhysicsWorld(frame: frame)
        guard let bodyA = bodyA, let bodyB = bodyB else {
            XCTFail("Init should not fail")
            return
        }
        test.insert(body: bodyA)
        var expected = PhysicsWorld(frame: frame, bodies: [bodyA])
        XCTAssertEqual(expected, test)

        test.insert(body: bodyA)
        XCTAssertEqual(expected, test)

        test.insert(body: bodyB)
        expected = PhysicsWorld(frame: frame, bodies: [bodyA, bodyB])
        XCTAssertEqual(expected, test)
    }

    func testContains() {
        var test = PhysicsWorld(frame: frame)
        guard let bodyA = bodyA, let bodyB = bodyB else {
            XCTFail("Init should not fail")
            return
        }
        XCTAssertFalse(test.contains(body: bodyA))
        test.insert(body: bodyA)
        XCTAssertTrue(test.contains(body: bodyA))

        test = PhysicsWorld(frame: frame, bodies: [bodyB])
        XCTAssertFalse(test.contains(body: bodyA))
        XCTAssertTrue(test.contains(body: bodyB))
    }

    func testRemove_emptyWorld_noChange() {
        let test = PhysicsWorld(frame: frame)
        guard let bodyA = bodyA else {
            XCTFail("Init should not fail")
            return
        }
        test.remove(body: bodyA)
        let expected = PhysicsWorld(frame: frame)
        XCTAssertEqual(expected, test)
    }

    func testRemove_bodyExists_bodyDeleted() {
        guard let bodyA = bodyA, let bodyB = bodyB else {
            XCTFail("Init should not fail")
            return
        }
        var test = PhysicsWorld(frame: frame, bodies: [bodyA])
        test.remove(body: bodyB)
        var expected = PhysicsWorld(frame: frame, bodies: [bodyA])
        XCTAssertEqual(expected, test)

        test.remove(body: bodyA)
        expected = PhysicsWorld(frame: frame)
        XCTAssertEqual(expected, test)

        test = PhysicsWorld(frame: frame, bodies: [bodyB, bodyA])
        test.remove(body: bodyB)
        expected = PhysicsWorld(frame: frame, bodies: [bodyA])
        XCTAssertEqual(expected, test)
    }

    func testUpdate() {
        let test = PhysicsWorld(frame: frame)
        guard let bodyA = bodyA, let bodyB = bodyB else {
            XCTFail("Init should not fail")
            return
        }
        test.insert(body: bodyA)
        test.insert(body: bodyB)
        test.update(time: 2)

        let expectedPositionB = CGPoint(x: 72, y: 109.62)
        let expectedVelocityB = CGVector(dx: 1, dy: 19.62)
        let expectedNewB = PhysicsBall(
            pos: expectedPositionB,
            radius: 30,
            restitution: 0.8,
            velo: expectedVelocityB,
            accel: CGVector(dx: 0, dy: 9.81)
        )
        guard let newB = expectedNewB else {
            XCTFail("Init should not fail")
            return
        }
        let expected = PhysicsWorld(frame: frame, bodies: [bodyA, newB])
        compareWorlds(expected: expected, actual: test)
    }

    private func compareWorlds(expected: PhysicsWorld, actual: PhysicsWorld) {
        XCTAssertEqual(expected.dimensions, actual.dimensions)
        let expectedBodies = Array(expected.bodies)
        let actualBodies = Array(actual.bodies)
        XCTAssertEqual(expectedBodies.count, actualBodies.count)
        actualBodies.forEach { XCTAssertTrue(expectedBodies.contains($0)) }
    }

}
