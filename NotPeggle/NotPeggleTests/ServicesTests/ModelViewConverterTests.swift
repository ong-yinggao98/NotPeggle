//
//  ModelViewConverterTests.swift
//  NotPeggleTests
//
//  Created by Ying Gao on 27/1/21.
//

import XCTest
@testable import NotPeggle

class ModelViewConverterTests: XCTestCase {

    typealias MVC = ModelViewConverter

    func testCreatePeg() {
        let zero = CGPoint.zero
        let peg = MVC.pegFromCGPoint(color: .orange, at: zero)
        let expected = Peg(centerX: 0, centerY: 0, color: .orange)
        XCTAssertEqual(expected, peg)
    }

    func testCreatePegFromView() {
        let origin = CGPoint.zero
        let viewRadius = CGFloat(Constants.pegRadius)
        let pegView = PegView(center: origin, color: .blue, radius: viewRadius)
        let expected = Peg(centerX: 0, centerY: 0, color: .blue)
        let actual = MVC.pegFromView(pegView)
        XCTAssertEqual(expected, actual)
    }

    func testCreateViewFromPeg() {
        let origin = CGPoint.zero
        let viewRadius = CGFloat(Constants.pegRadius)
        let expected = PegView(center: origin, color: .orange, radius: viewRadius)
        let peg = Peg(centerX: 0, centerY: 0, color: .orange)
        let actual = MVC.viewFromPeg(peg)
        XCTAssertEqual(expected, actual)
    }

    func testModelRepresentation() {
        let test = CGPoint.zero
        let expected = Point(x: 0, y: 0)
        let actual = MVC.pointFromCGPoint(point: test)
        XCTAssertEqual(expected, actual)
    }
}
