//
//  VectorExtensionTests.swift
//  NotPeggleTests
//
//  Created by Ying Gao on 10/2/21.
//

import XCTest
@testable import NotPeggle

class VectorExtensionTests: XCTestCase {

    let marginOfError: CGFloat = 1e-10

    func testMagnitude() {
        var vector = CGVector.zero
        XCTAssertEqual(vector.magnitude, 0)

        vector = CGVector(dx: 1, dy: 1)
        XCTAssertEqual(vector.magnitude, sqrt(2))

        vector = CGVector(dx: -3, dy: 4)
        XCTAssertEqual(vector.magnitude, 5)

        vector = CGVector(dx: -2, dy: -2)
        XCTAssertEqual(vector.magnitude, sqrt(8))

        vector = CGVector(dx: 0, dy: 1)
        XCTAssertEqual(vector.magnitude, 1)
    }

    func testAngleGetter_zeroVector_returnsZero() {
        let vector = CGVector.zero
        XCTAssertEqual(vector.angleInRads, 0)
    }

    func testAngleGetter() {
        var vector = CGVector(dx: 0, dy: 1)
        XCTAssertEqual(vector.angleInRads, CGFloat.pi / 2)

        vector = CGVector(dx: 1, dy: 0)
        XCTAssertEqual(vector.angleInRads, 0)

        vector = CGVector(dx: 1, dy: 1)
        XCTAssertEqual(vector.angleInRads, CGFloat.pi / 4)

        vector = CGVector(dx: -1, dy: 1)
        XCTAssertEqual(vector.angleInRads, -CGFloat.pi / 4)

        vector = CGVector(dx: -1, dy: -1)
        XCTAssertEqual(vector.angleInRads, CGFloat.pi / 4)

        vector = CGVector(dx: -1, dy: 0)
        XCTAssertEqual(vector.angleInRads, 0)
    }

    func testRotateBy_positiveDxNegativeDy() {
        var vector = CGVector(dx: 1, dy: -1)
        vector.rotate(by: CGFloat.pi / 4)
        var expected = CGVector(dx: sqrt(2), dy: 0)
        TestUtils.compareVectors(expected: expected, actual: vector)

        vector = CGVector(dx: 1, dy: -1)
        vector.rotate(by: -CGFloat.pi / 2)
        expected = CGVector(dx: -1, dy: -1)
        TestUtils.compareVectors(expected: expected, actual: vector)

        vector = CGVector(dx: 1, dy: -1)
        vector.rotate(by: CGFloat.pi)
        expected = CGVector(dx: -1, dy: 1)
        TestUtils.compareVectors(expected: expected, actual: vector)
    }

    func testRotateBy_negativeDxNegativeDy() {
        var vector = CGVector(dx: -1, dy: -1)
        vector.rotate(by: CGFloat.pi / 4)
        var expected = CGVector(dx: 0, dy: -sqrt(2))
        TestUtils.compareVectors(expected: expected, actual: vector)

        vector = CGVector(dx: -1, dy: -1)
        vector.rotate(by: -CGFloat.pi / 2)
        expected = CGVector(dx: -1, dy: 1)
        TestUtils.compareVectors(expected: expected, actual: vector)
    }

    func testRotateBy_positiveDxPositiveDy() {
        var vector = CGVector(dx: 1, dy: 1)
        vector.rotate(by: CGFloat.pi / 4)
        var expected = CGVector(dx: 0, dy: sqrt(2))
        TestUtils.compareVectors(expected: expected, actual: vector)

        vector = CGVector(dx: 1, dy: 1)
        vector.rotate(by: -CGFloat.pi / 2)
        expected = CGVector(dx: 1, dy: -1)
        TestUtils.compareVectors(expected: expected, actual: vector)
    }

    func testRotateBy_negativeDxPositiveDy() {
        var vector = CGVector(dx: -1, dy: 1)
        vector.rotate(by: CGFloat.pi / 4)
        var expected = CGVector(dx: -sqrt(2), dy: 0)
        TestUtils.compareVectors(expected: expected, actual: vector)

        vector = CGVector(dx: -1, dy: 1)
        vector.rotate(by: -CGFloat.pi / 2)
        expected = CGVector(dx: 1, dy: 1)
        TestUtils.compareVectors(expected: expected, actual: vector)
    }

    func testDot() {
        let vectorA = CGVector(dx: 2, dy: 3)
        let vectorB = CGVector(dx: -1.5, dy: 1)
        let vectorC = CGVector(dx: -1.5, dy: 3)
        XCTAssertEqual(vectorA.dot(other: vectorB), 0)
        XCTAssertTrue(vectorA.isPerpendicularTo(other: vectorB))
        XCTAssertEqual(vectorA.dot(other: vectorC), 6)
        XCTAssertFalse(vectorA.isPerpendicularTo(other: vectorC))
    }

    func testScale() {
        var vector = CGVector.zero
        vector.scale(factor: 3)
        XCTAssertEqual(CGVector.zero, vector)

        vector = CGVector(dx: 1, dy: 1)
        vector.scale(factor: 0.2)
        var expected = CGVector(dx: 0.2, dy: 0.2)
        XCTAssertEqual(expected, vector)

        vector.scale(factor: -5)
        expected = CGVector(dx: -1, dy: -1)
        XCTAssertEqual(expected, vector)
    }

}
