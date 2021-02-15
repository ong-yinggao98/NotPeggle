//
//  PegModeButtonTests.swift
//  NotPeggleTests
//
//  Created by Ying Gao on 27/1/21.
//

import XCTest
@testable import NotPeggle

class PegModeButtonTests: XCTestCase {

    func testSelection() {
        let button = PegModeButton()

        button.isSelected = false
        XCTAssertTrue(button.alpha < 1)

        button.isSelected = true
        XCTAssertEqual(button.alpha, PegModeButton.selectedAlpha)

    }
}
