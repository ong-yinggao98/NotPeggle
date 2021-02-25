//
//  CGPointExtensions.swift
//  NotPeggleTests
//
//  Created by Ying Gao on 9/2/21.
//

import XCTest
@testable import NotPeggle

class PointExtensionTests: XCTestCase {

    let origin = CGPoint.zero
    let pointRight = CGPoint(x: 2, y: 0)
    let pointDown = CGPoint(x: 0, y: 2)
    let pointLeft = CGPoint(x: -2, y: 0)
    let pointUp = CGPoint(x: 0, y: -2)
    let pointAngled = CGPoint(x: 2, y: 2)
    let pointClose = CGPoint(x: -0.1, y: 0.1)

    func testUnitNormalTo_samePoint_zeroVector() {
        let result = pointAngled.unitNormalTo(point: pointAngled)
        XCTAssertEqual(CGVector.zero, result)
    }

    func testUnitNormalTo_differentPoint_unitVector() {
        var result = origin.unitNormalTo(point: pointRight)
        var expected = CGVector(dx: 1, dy: 0)
        XCTAssertEqual(expected, result)

        result = origin.unitNormalTo(point: pointDown)
        expected = CGVector(dx: 0, dy: 1)
        XCTAssertEqual(expected, result)

        result = origin.unitNormalTo(point: pointLeft)
        expected = CGVector(dx: -1, dy: 0)
        XCTAssertEqual(expected, result)

        result = origin.unitNormalTo(point: pointUp)
        expected = CGVector(dx: 0, dy: -1)
        XCTAssertEqual(expected, result)

        result = origin.unitNormalTo(point: pointAngled)
        expected = CGVector(dx: 1 / sqrt(2), dy: 1 / sqrt(2))
        XCTAssertEqual(expected, result)

        result = origin.unitNormalTo(point: pointClose)
        expected = CGVector(dx: -1 / sqrt(2), dy: 1 / sqrt(2))
        XCTAssertEqual(expected, result)
    }

    func testUnitTangentTo_samePoint_zeroVector() {
        let result = pointAngled.unitTangentTo(point: pointAngled)
        XCTAssertEqual(CGVector.zero, result)
    }

    func testUnitTangentTo_differentPoint_unitVector() {
        var result = origin.unitTangentTo(point: pointRight)
        var normal = origin.unitNormalTo(point: pointRight)
        var expected = CGVector(dx: 0, dy: 1)
        XCTAssertEqual(expected, result)
        XCTAssertTrue(result.isPerpendicularTo(other: normal))

        result = origin.unitTangentTo(point: pointDown)
        expected = CGVector(dx: -1, dy: 0)
        XCTAssertEqual(expected, result)

        result = origin.unitTangentTo(point: pointLeft)
        expected = CGVector(dx: 0, dy: -1)
        XCTAssertEqual(expected, result)

        result = origin.unitTangentTo(point: pointUp)
        expected = CGVector(dx: 1, dy: 0)
        XCTAssertEqual(expected, result)

        result = origin.unitTangentTo(point: pointAngled)
        expected = CGVector(dx: -1 / sqrt(2), dy: 1 / sqrt(2))
        XCTAssertEqual(expected, result)

        result = origin.unitTangentTo(point: pointClose)
        normal = origin.unitNormalTo(point: pointClose)
        expected = CGVector(dx: -1 / sqrt(2), dy: -1 / sqrt(2))
        XCTAssertEqual(expected, result)
        XCTAssertTrue(result.isPerpendicularTo(other: normal))
    }

}
