//
//  PegTests.swift
//  NotPeggleTests
//
//  Created by Ying Gao on 27/1/21.
//

import XCTest
@testable import NotPeggle

class PegTests: XCTestCase {

    func testOverlapsWith() {
        let minDist = 2 * Constants.pegRadius
        let center = Point(x: 0.0, y: 0.0)
        let centerMinDist = Point(x: minDist, y: 0.0)
        let centerOverlap = Point(x: minDist - 0.1, y: 0.0)
        let centerFarAway = Point(x: minDist + 0.1, y: 0.0)

        let peg = Peg(center: center, color: .blue)
        let pegMinDist = Peg(center: centerMinDist, color: .blue)
        let pegOverlap = Peg(center: centerOverlap, color: .blue)
        let pegFar = Peg(center: centerFarAway, color: .blue)

        XCTAssertTrue(peg.overlapsWith(other: pegOverlap))
        XCTAssertTrue(peg.overlapsWith(other: peg))
        XCTAssertFalse(peg.overlapsWith(other: pegMinDist))
        XCTAssertFalse(peg.overlapsWith(other: pegFar))

        let orangePeg = Peg(center: centerMinDist, color: .orange)
        XCTAssertFalse(orangePeg.overlapsWith(other: peg))
    }

    func testTooCloseToEdges_leftTopBorder() {
        let radius = Constants.pegRadius
        let bounds = 3 * radius
        let predicate = { (peg: Peg) in
            peg.tooCloseToEdges(width: bounds, height: bounds)
        }

        var test = Peg(centerX: radius, centerY: radius, color: .blue)
        XCTAssertFalse(predicate(test))
        test = Peg(centerX: radius - 0.1, centerY: radius, color: .blue)
        XCTAssertTrue(predicate(test))
        test = Peg(centerX: radius, centerY: radius - 0.1, color: .blue)
        XCTAssertTrue(predicate(test))
        test = Peg(centerX: radius + 0.1, centerY: radius, color: .blue)
        XCTAssertFalse(predicate(test))
        test = Peg(centerX: radius, centerY: radius + 0.1, color: .blue)
        XCTAssertFalse(predicate(test))
    }

    func testTooCloseToEdges_rightBottomBorder() {
        let radius = Constants.pegRadius
        let bounds = 3 * radius
        let predicate = { (peg: Peg) in
            peg.tooCloseToEdges(width: bounds, height: bounds)
        }

        let positiveLimit = bounds - radius
        var test = Peg(centerX: positiveLimit, centerY: positiveLimit, color: .blue)
        XCTAssertFalse(predicate(test))
        test = Peg(centerX: positiveLimit + 0.1, centerY: positiveLimit, color: .blue)
        XCTAssertTrue(predicate(test))
        test = Peg(centerX: positiveLimit - 0.1, centerY: radius, color: .blue)
        XCTAssertFalse(predicate(test))
        test = Peg(centerX: radius, centerY: positiveLimit - 0.1, color: .blue)
        XCTAssertFalse(predicate(test))
    }

    func testContainsPoint() {
        let peg = Peg(centerX: 0.0, centerY: 0.0, color: .orange)
        let radius = peg.radius

        var test = Point(x: radius, y: 0.0)
        XCTAssertFalse(peg.contains(point: test))
        test = Point(x: radius - 0.1, y: 0.0)
        XCTAssertTrue(peg.contains(point: test))
        test = Point(x: radius + 0.1, y: 0.0)
        XCTAssertFalse(peg.contains(point: test))

        test = Point(x: 0.0, y: radius)
        XCTAssertFalse(peg.contains(point: test))
        test = Point(x: 0.0, y: radius - 0.1)
        XCTAssertTrue(peg.contains(point: test))
        test = Point(x: 0.0, y: radius + 0.1)
        XCTAssertFalse(peg.contains(point: test))

        test = Point(x: 23.0, y: 23.0)
        XCTAssertFalse(peg.contains(point: test))
        test = Point(x: 15.0, y: 15.0)
        XCTAssertTrue(peg.contains(point: test))
    }

    func testRecenterTo() {
        let peg = Peg(centerX: 0.0, centerY: 0.0, color: .blue)
        let newCenter = Point(x: 2.0, y: 3.0)

        let expected = Peg(centerX: 2.0, centerY: 3.0, color: .blue)
        let actual = peg.recenterTo(newCenter)
        XCTAssertEqual(expected, actual)
    }

    func testResize() {
        let minSize = Constants.pegRadius
        let maxSize = 2 * minSize
        let peg = Peg(center: Point(x: 0, y: 0), color: .blue)
        let angle = peg.angle

        var actual = peg.resizeTo(minSize - 0.1)
        var expected = Peg(center: Point(x: 0, y: 0), color: .blue, radius: minSize, angle: angle)
        XCTAssertEqual(expected, actual)

        actual = peg.resizeTo(minSize)
        expected = Peg(center: Point(x: 0, y: 0), color: .blue, radius: minSize, angle: angle)
        XCTAssertEqual(expected, actual)

        actual = peg.resizeTo(minSize + 0.1)
        expected = Peg(center: Point(x: 0, y: 0), color: .blue, radius: minSize + 0.1, angle: angle)
        XCTAssertEqual(expected, actual)

        actual = peg.resizeTo(maxSize)
        expected = Peg(center: Point(x: 0, y: 0), color: .blue, radius: maxSize, angle: angle)
        XCTAssertEqual(expected, actual)

        actual = peg.resizeTo(maxSize + 0.1)
        expected = Peg(center: Point(x: 0, y: 0), color: .blue, radius: maxSize, angle: angle)
        XCTAssertEqual(expected, actual)
    }

    func testRotate() {
        let minAngle = 0.0
        let maxAngle = 2 * Double.pi
        let peg = Peg(center: Point(x: 0, y: 0), color: .orange)
        let radius = peg.radius

        var actual = peg.rotateTo(minAngle - 0.1)
        var expected = Peg(center: Point(x: 0, y: 0), color: .orange, radius: radius, angle: minAngle)
        XCTAssertEqual(expected, actual)

        actual = peg.rotateTo(minAngle)
        expected = Peg(center: Point(x: 0, y: 0), color: .orange, radius: radius, angle: minAngle)
        XCTAssertEqual(expected, actual)

        actual = peg.rotateTo(minAngle + 0.1)
        expected = Peg(center: Point(x: 0, y: 0), color: .orange, radius: radius, angle: minAngle + 0.1)
        XCTAssertEqual(expected, actual)

        actual = peg.rotateTo(maxAngle)
        expected = Peg(center: Point(x: 0, y: 0), color: .orange, radius: radius, angle: maxAngle)
        XCTAssertEqual(expected, actual)

        actual = peg.rotateTo(maxAngle + 0.1)
        expected = Peg(center: Point(x: 0, y: 0), color: .orange, radius: radius, angle: maxAngle)
        XCTAssertEqual(expected, actual)
    }
}
