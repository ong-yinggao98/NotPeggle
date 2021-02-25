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
        let center = Point(xCoord: 0.0, yCoord: 0.0)
        let centerMinDist = Point(xCoord: minDist, yCoord: 0.0)
        let centerOverlap = Point(xCoord: minDist - 0.1, yCoord: 0.0)
        let centerFarAway = Point(xCoord: minDist + 0.1, yCoord: 0.0)

        let peg = Peg(center: center, color: .blue)
        let pegMinDist = Peg(center: centerMinDist, color: .blue)
        let pegOverlap = Peg(center: centerOverlap, color: .blue)
        let pegFar = Peg(center: centerFarAway, color: .blue)

        XCTAssertTrue(peg.overlapsWith(peg: pegOverlap))
        XCTAssertTrue(peg.overlapsWith(peg: peg))
        XCTAssertFalse(peg.overlapsWith(peg: pegMinDist))
        XCTAssertFalse(peg.overlapsWith(peg: pegFar))

        let orangePeg = Peg(center: centerMinDist, color: .orange)
        XCTAssertFalse(orangePeg.overlapsWith(peg: peg))
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

        var test = Point(xCoord: radius, yCoord: 0.0)
        XCTAssertFalse(peg.contains(point: test))
        test = Point(xCoord: radius - 0.1, yCoord: 0.0)
        XCTAssertTrue(peg.contains(point: test))
        test = Point(xCoord: radius + 0.1, yCoord: 0.0)
        XCTAssertFalse(peg.contains(point: test))

        test = Point(xCoord: 0.0, yCoord: radius)
        XCTAssertFalse(peg.contains(point: test))
        test = Point(xCoord: 0.0, yCoord: radius - 0.1)
        XCTAssertTrue(peg.contains(point: test))
        test = Point(xCoord: 0.0, yCoord: radius + 0.1)
        XCTAssertFalse(peg.contains(point: test))

        test = Point(xCoord: 23.0, yCoord: 23.0)
        XCTAssertFalse(peg.contains(point: test))
        test = Point(xCoord: 15.0, yCoord: 15.0)
        XCTAssertTrue(peg.contains(point: test))
    }

    func testRecenterTo() {
        let peg = Peg(centerX: 0.0, centerY: 0.0, color: .blue)
        let newCenter = Point(xCoord: 2.0, yCoord: 3.0)

        let expected = Peg(centerX: 2.0, centerY: 3.0, color: .blue)
        let actual = peg.recenterTo(newCenter)
        XCTAssertEqual(expected, actual)
    }
}
