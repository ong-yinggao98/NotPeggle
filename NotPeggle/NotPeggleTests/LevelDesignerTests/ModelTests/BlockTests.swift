//
//  Rect2DTests.swift
//  NotPeggleTests
//
//  Created by Ying Gao on 25/2/21.
//

import XCTest
@testable import NotPeggle

class BlockTests: XCTestCase {

    let testCase = Block(
        center: Point(x: 2, y: 4),
        height: 25,
        angle: Double.pi / 4
    )

    func testOverlapsWith_nonOverlappingBlock_false() {
        testCase.points.forEach { print("x: \($0.x), y: \($0.y)") }
        var block = Block(
            center: Point(x: -45, y: 6),
            height: 20,
            angle: 0
        )
        XCTAssertFalse(testCase.overlapsWith(other: block))

        block = Block(
            center: Point(x: -17, y: -33),
            height: 20,
            angle: 0
        )
        XCTAssertFalse(testCase.overlapsWith(other: block))

        block = Block(
            center: Point(x: 49, y: 2),
            height: 20,
            angle: 0
        )
        XCTAssertFalse(testCase.overlapsWith(other: block))

        block = Block(
            center: Point(x: 21, y: 41),
            height: 20,
            angle: 0
        )
        XCTAssertFalse(testCase.overlapsWith(other: block))
    }

    func testOverlapsWith_overlappingBlock_true() {
        let overlappingBlock = Block(
            center: Point(x: 0.30, y: 0.88),
            height: 3,
            angle: 0
        )
        XCTAssertTrue(testCase.overlapsWith(other: overlappingBlock))
    }

    func testOverlapsWith_nonOverlappingPeg_false() {
        // bottom
        var peg = Peg(center: Point(x: 29, y: -23), color: .blue)
        XCTAssertFalse(testCase.overlapsWith(other: peg))

        // right
        peg = Peg(center: Point(x: 38, y: 40), color: .orange)
        XCTAssertFalse(testCase.overlapsWith(other: peg))

        // top
        peg = Peg(center: Point(x: -25, y: 31), color: .blue)
        XCTAssertFalse(testCase.overlapsWith(other: peg))

        // left
        peg = Peg(center: Point(x: -34, y: -32), color: .orange)
        XCTAssertFalse(testCase.overlapsWith(other: peg))
    }

    func testOverlapsWith_overlappingPeg_true() {
        // bottom
        var peg = Peg(center: Point(x: 28, y: -22), color: .blue)
        XCTAssertTrue(testCase.overlapsWith(other: peg))

        // right
        peg = Peg(center: Point(x: 37, y: 39), color: .orange)
        XCTAssertTrue(testCase.overlapsWith(other: peg))

        // top
        peg = Peg(center: Point(x: -24, y: 30), color: .blue)
        XCTAssertTrue(testCase.overlapsWith(other: peg))

        // left
        peg = Peg(center: Point(x: -33, y: -31), color: .orange)
        XCTAssertTrue(testCase.overlapsWith(other: peg))
    }

    func testContainsPoint() {
        var point = Point(x: -15, y: -13)
        XCTAssertTrue(testCase.contains(point: point))
        point = Point(x: -16, y: -14)
        XCTAssertFalse(testCase.contains(point: point))

        point = Point(x: 11, y: -4)
        XCTAssertTrue(testCase.contains(point: point))
        point = Point(x: 12, y: -5)
        XCTAssertFalse(testCase.contains(point: point))

        point = Point(x: 19, y: 21)
        XCTAssertTrue(testCase.contains(point: point))
        point = Point(x: 20, y: 22)
        XCTAssertFalse(testCase.contains(point: point))

        point = Point(x: -7, y: 11)
        XCTAssertTrue(testCase.contains(point: point))
        point = Point(x: -8, y: 12)
        XCTAssertFalse(testCase.contains(point: point))
    }

    func testTooCloseToEdges() {
        let width = 300.0, height = 300.0
        XCTAssertTrue(testCase.tooCloseToEdges(width: width, height: height))

        let middleRect = Block(
            center: Point(x: 100, y: 130),
            height: 30,
            angle: Double.pi / 6
        )
        XCTAssertFalse(middleRect.tooCloseToEdges(width: width, height: height))

        let edgeRect = Block(
            center: Point(x: 295, y: 295),
            height: 10,
            angle: -Double.pi / 4
        )
        XCTAssertTrue(edgeRect.tooCloseToEdges(width: width, height: height))
    }

}
