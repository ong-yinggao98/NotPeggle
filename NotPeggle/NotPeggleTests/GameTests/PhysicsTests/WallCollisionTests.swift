//
//  MorePhysicsBodyTests.swift
//  NotPeggleTests
//
//  Created by Ying Gao on 14/2/21.
//

import XCTest
@testable import NotPeggle

extension PhysicsBodyTests {

    var frame: CGRect {
        return CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 300, height: 300))
    }

    var topLeftHitter: PhysicsBody? {
        return PhysicsBody(
            pos: CGPoint(x: 10, y: 10),
            radius: 10,
            restitution: 0.8,
            velo: CGVector(dx: -1, dy: -1),
            accel: CGVector.zero
        )
    }

    var topRightHitter: PhysicsBody? {
        return PhysicsBody(
            pos: CGPoint(x: 290, y: 10),
            radius: 10,
            restitution: 0.8,
            velo: CGVector(dx: 1, dy: -1),
            accel: CGVector.zero
        )
    }

    var bottomLeftHitter: PhysicsBody? {
        return PhysicsBody(
            pos: CGPoint(x: 10, y: 290),
            radius: 10,
            restitution: 0.8,
            velo: CGVector(dx: -1, dy: 1),
            accel: CGVector.zero
        )
    }

    var bottomRightHitter: PhysicsBody? {
        return PhysicsBody(
            pos: CGPoint(x: 290, y: 290),
            radius: 10,
            restitution: 0.8,
            velo: CGVector(dx: 1, dy: 1),
            accel: CGVector.zero
        )
    }

    // MARK: Corner Collision Tests
    func testWallCollision_topleftEnabled() {
        let frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 300, height: 300))
        let wallHitter = topLeftHitter
        wallHitter?.handleCollisionWithBorders(frame: frame, borders: [.top, .left])
        let expected = PhysicsBody(
            pos: CGPoint(x: 10, y: 10),
            radius: 10,
            restitution: 0.8,
            velo: CGVector(dx: 0.8, dy: 0.8),
            accel: CGVector.zero
        )
        XCTAssertEqual(expected, wallHitter)
        let nonHitter = PhysicsBody(
            pos: CGPoint(x: 10, y: 10),
            radius: 10, restitution: 0.8,
            velo: CGVector(dx: 0.8, dy: 0.8),
            accel: CGVector.zero
        )
        nonHitter?.handleCollisionWithBorders(frame: frame, borders: [.top, .left])
        XCTAssertEqual(expected, nonHitter)
    }

    func testWallCollision_topRightEnabled() {
        let wallHitter = topRightHitter
        wallHitter?.handleCollisionWithBorders(frame: frame, borders: [.top, .right])
        let expected = PhysicsBody(
            pos: CGPoint(x: 290, y: 10),
            radius: 10,
            restitution: 0.8,
            velo: CGVector(dx: -0.8, dy: 0.8),
            accel: CGVector.zero
        )
        XCTAssertEqual(expected, wallHitter)
        let nonHitter = PhysicsBody(
            pos: CGPoint(x: 290, y: 10),
            radius: 10, restitution: 0.8,
            velo: CGVector(dx: -0.8, dy: 0.8),
            accel: CGVector.zero
        )
        nonHitter?.handleCollisionWithBorders(frame: frame, borders: [.top, .right])
        XCTAssertEqual(expected, nonHitter)
    }

    func testWallCollision_bottomLeftEnabled() {
        let wallHitter = bottomLeftHitter
        wallHitter?.handleCollisionWithBorders(frame: frame, borders: [.bottom, .left])
        let expected = PhysicsBody(
            pos: CGPoint(x: 10, y: 290),
            radius: 10,
            restitution: 0.8,
            velo: CGVector(dx: 0.8, dy: -0.8),
            accel: CGVector.zero
        )
        XCTAssertEqual(expected, wallHitter)
        let nonHitter = PhysicsBody(
            pos: CGPoint(x: 10, y: 290),
            radius: 10, restitution: 0.8,
            velo: CGVector(dx: 0.8, dy: -0.8),
            accel: CGVector.zero
        )
        nonHitter?.handleCollisionWithBorders(frame: frame, borders: [.bottom, .left])
        XCTAssertEqual(expected, nonHitter)
    }

    func testWallCollision_bottomRightEnabled() {
        let wallHitter = bottomRightHitter
        wallHitter?.handleCollisionWithBorders(frame: frame, borders: [.bottom, .right])
        let expected = PhysicsBody(
            pos: CGPoint(x: 290, y: 290),
            radius: 10,
            restitution: 0.8,
            velo: CGVector(dx: -0.8, dy: -0.8),
            accel: CGVector.zero
        )
        XCTAssertEqual(expected, wallHitter)
        let nonHitter = PhysicsBody(
            pos: CGPoint(x: 290, y: 290),
            radius: 10, restitution: 0.8,
            velo: CGVector(dx: -0.8, dy: -0.8),
            accel: CGVector.zero
        )
        nonHitter?.handleCollisionWithBorders(frame: frame, borders: [.bottom, .right])
        XCTAssertEqual(expected, nonHitter)
    }

    // MARK: Wall Collision Tests
    func testWallCollision_leftWall() {
        let wallHitter = topLeftHitter
        wallHitter?.handleCollisionWithBorders(frame: frame, borders: [.left])
        let expected = PhysicsBody(
            pos: CGPoint(x: 10, y: 10),
            radius: 10,
            restitution: 0.8,
            velo: CGVector(dx: 0.8, dy: -0.8),
            accel: CGVector.zero
        )
        XCTAssertEqual(expected, wallHitter)
        let nonHitter = PhysicsBody(
            pos: CGPoint(x: 10, y: 10),
            radius: 10,
            restitution: 0.8,
            velo: CGVector(dx: 0.8, dy: -0.8),
            accel: CGVector.zero
        )
        nonHitter?.handleCollisionWithBorders(frame: frame, borders: [.left])
        XCTAssertEqual(expected, nonHitter)
    }

    func testWallCollision_topWall() {
        let wallHitter = topRightHitter
        wallHitter?.handleCollisionWithBorders(frame: frame, borders: [.top])
        let expected = PhysicsBody(
            pos: CGPoint(x: 290, y: 10),
            radius: 10,
            restitution: 0.8,
            velo: CGVector(dx: 0.8, dy: 0.8),
            accel: CGVector.zero
        )
        XCTAssertEqual(expected, wallHitter)
        let nonHitter = PhysicsBody(
            pos: CGPoint(x: 290, y: 10),
            radius: 10,
            restitution: 0.8,
            velo: CGVector(dx: 0.8, dy: 0.8),
            accel: CGVector.zero
        )
        nonHitter?.handleCollisionWithBorders(frame: frame, borders: [.left])
        XCTAssertEqual(expected, nonHitter)
    }

    func testWallCollision_rightWall() {
        let wallHitter = topRightHitter
        wallHitter?.handleCollisionWithBorders(frame: frame, borders: [.right])
        let expected = PhysicsBody(
            pos: CGPoint(x: 290, y: 10),
            radius: 10,
            restitution: 0.8,
            velo: CGVector(dx: -0.8, dy: -0.8),
            accel: CGVector.zero
        )
        XCTAssertEqual(expected, wallHitter)
        let nonHitter = PhysicsBody(
            pos: CGPoint(x: 290, y: 10),
            radius: 10,
            restitution: 0.8,
            velo: CGVector(dx: -0.8, dy: -0.8),
            accel: CGVector.zero
        )
        nonHitter?.handleCollisionWithBorders(frame: frame, borders: [.right])
        XCTAssertEqual(expected, nonHitter)
    }

    func testWallCollision_bottomWall() {
        let wallHitter = bottomRightHitter
        wallHitter?.handleCollisionWithBorders(frame: frame, borders: [.bottom])
        let expected = PhysicsBody(
            pos: CGPoint(x: 290, y: 290),
            radius: 10,
            restitution: 0.8,
            velo: CGVector(dx: 0.8, dy: -0.8),
            accel: CGVector.zero
        )
        XCTAssertEqual(expected, wallHitter)
        let nonHitter = PhysicsBody(
            pos: CGPoint(x: 290, y: 290),
            radius: 10,
            restitution: 0.8,
            velo: CGVector(dx: 0.8, dy: -0.8),
            accel: CGVector.zero
        )
        nonHitter?.handleCollisionWithBorders(frame: frame, borders: [.bottom])
        XCTAssertEqual(expected, nonHitter)
    }
}
