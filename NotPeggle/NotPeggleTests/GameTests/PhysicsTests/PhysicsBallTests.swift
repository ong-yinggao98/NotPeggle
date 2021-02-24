//
//  PhysBodyTests.swift
//  NotPeggleTests
//
//  Created by Ying Gao on 9/2/21.
//

import XCTest
@testable import NotPeggle

class PhysicsBallTests: XCTestCase {

    // MARK: PhysicsBody test cases
    var stationaryBody: PhysicsBall? {
        return PhysicsBall(
            pos: CGPoint.zero,
            radius: 32,
            restitution: 0,
            velo: CGVector.zero,
            accel: CGVector.zero
        )
    }

    var movingBody: PhysicsBall? {
        let velocity = CGVector(dx: -2, dy: 0)
        return PhysicsBall(
            pos: CGPoint(x: 70, y: 0),
            radius: 32,
            restitution: 1,
            velo: velocity,
            accel: CGVector.zero
        )
    }

    var acceleratingBody: PhysicsBall? {
        return PhysicsBall(
            pos: CGPoint.zero,
            radius: 32,
            restitution: 0,
            velo: CGVector.zero,
            accel: CGVector(dx: 0, dy: 1))
    }

    let duration = TimeInterval(3.5)

    // MARK: Tests

    func testConstr() {
        XCTAssertNotNil(stationaryBody)

        var fail = PhysicsBall(
            pos: CGPoint.zero,
            radius: -3,
            restitution: 0,
            velo: CGVector.zero,
            accel: CGVector.zero
        )
        XCTAssertNil(fail)

        fail = PhysicsBall(
            pos: CGPoint.zero,
            radius: 0,
            restitution: 0,
            velo: CGVector.zero,
            accel: CGVector.zero
        )
        XCTAssertNil(fail)
    }

    func testCollides() {
        guard
            let body = stationaryBody,
            let otherBody = movingBody,
            let collidingBody = PhysicsBall(
                pos: CGPoint(x: 50, y: -50),
                radius: 40,
                restitution: 0,
                velo: CGVector.zero,
                accel: CGVector.zero
            )
        else {
            XCTFail("PhyBody initialisation should not fail")
            return
        }

        XCTAssertFalse(body.collides(with: body))
        XCTAssertFalse(body.collides(with: otherBody))
        XCTAssertTrue(body.collides(with: collidingBody))
    }

    func testUpdateProperties_stationary_noChange() {
        let body = stationaryBody
        body?.updateProperties(time: duration)
        XCTAssertEqual(stationaryBody, body)
    }

    func testUpdateProperties_constantVelo_recentered() {
        guard
            let body = movingBody,
            let stationary = stationaryBody
        else {
            XCTFail("Initialisation should not fail")
            return
        }
        body.updateProperties(time: duration)
        XCTAssertTrue(body.collides(with: stationary))

        let expectedPosition = CGPoint(x: 63, y: 0)
        XCTAssertEqual(expectedPosition, body.center)
    }

    func testUpdateProperties_accel_propertiesUpdated() {
        guard let body = acceleratingBody else {
            XCTFail("Initialisation should not fail")
            return
        }
        body.updateProperties(time: duration)

        let expectedVelocity = CGVector(dx: 0, dy: 3.5)
        let expectedPosition = CGPoint(x: 0, y: 6.125)
        XCTAssertEqual(body.center, expectedPosition)
        XCTAssertEqual(body.velocity, expectedVelocity)
    }

    // MARK: Collision test cases
    var collider: PhysicsBall? {
        let velocity = CGVector(dx: 4, dy: 0)
        return PhysicsBall(
            pos: CGPoint.zero,
            radius: 32,
            restitution: 1,
            velo: velocity,
            accel: CGVector.zero
        )
    }

    var topCollider: PhysicsBall? {
        let velocity = CGVector(dx: 0, dy: -4)
        return PhysicsBall(
            pos: CGPoint(x: 64, y: 4),
            radius: 32,
            restitution: 1,
            velo: velocity,
            accel: CGVector.zero
        )
    }

    var angledCollider: PhysicsBall? {
        let velocity = CGVector(dx: 4, dy: 0)
        return PhysicsBall(
            pos: CGPoint(x: 19, y: 45),
            radius: 32,
            restitution: 0.8,
            velo: velocity,
            accel: CGVector.zero
        )
    }

    var collidee: PhysicsBall? {
        return PhysicsBall(
            pos: CGPoint(x: 64, y: 0),
            radius: 32,
            restitution: 0,
            velo: CGVector.zero,
            accel: CGVector.zero
        )
    }

    func testHandleCollision_direct() {
        guard
            let collider = collider,
            let collidee = collidee
        else {
            XCTFail("This should not fail")
            return
        }

        collider.handleCollision(object: collidee)
        let expected = CGVector(dx: -4, dy: 0)
        let actual = collider.velocity
        TestUtils.compareVectors(expected: expected, actual: actual)
    }

    func testHandleCollision_topDown() {
        guard
            let collider = topCollider,
            let collidee = collidee
        else {
            XCTFail("This should not fail")
            return
        }

        collider.handleCollision(object: collidee)
        let expected = CGVector(dx: 0, dy: 4)
        let actual = collider.velocity
        TestUtils.compareVectors(expected: expected, actual: actual)
    }

    func testHandleCollision_glancing() {
        guard
            let collider = angledCollider,
            let collidee = collidee
        else {
            XCTFail("This should not fail")
            return
        }

        collider.handleCollision(object: collidee)
        let expected = CGVector(dx: 0, dy: 3.2) // it only keeps 0.8 of its magnitude
        let actual = collider.velocity
        TestUtils.compareVectors(expected: expected, actual: actual)
    }

}
