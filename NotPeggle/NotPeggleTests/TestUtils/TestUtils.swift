//
//  TestUtils.swift
//  NotPeggleTests
//
//  Created by Ying Gao on 10/2/21.
//

import XCTest
@testable import NotPeggle

struct TestUtils {

    static let marginOfError: CGFloat = 1e-5

    static func compareVectors(expected: CGVector, actual: CGVector) {
        XCTAssertEqual(expected.dx, actual.dx, accuracy: marginOfError)
        XCTAssertEqual(expected.dy, actual.dy, accuracy: marginOfError)
    }

    static func comparePhysicsBodySets(expected: Set<PhysicsBody>, actual: Set<PhysicsBody>) {
        let expectedBodies = Array(expected)
        let actualBodies = Array(expected)
        XCTAssertEqual(expectedBodies.count, actualBodies.count)
        actualBodies.forEach { XCTAssertTrue(expectedBodies.contains($0)) }
    }
}
