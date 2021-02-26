//
//  ModelTests.swift
//  NotPeggleTests
//
//  Created by Ying Gao on 27/1/21.
//

import XCTest
@testable import NotPeggle

class ModelTests: XCTestCase {

    let height = 400.0
    let width = 300.0

    let peg = Peg(centerX: 32, centerY: 32, color: .blue, radius: 32.0)
    let pegCompatible = Peg(centerX: 103, centerY: 70, color: .orange, radius: 32.0)
    // Peg that only overlaps with peg
    let pegOverlap = Peg(centerX: 40, centerY: 35, color: .orange, radius: 32.0)
    // Peg that does not overlap with peg and pegCompatible
    let pegCompatible2 = Peg(centerX: 200, centerY: 80, color: .orange, radius: 32.0)

    // Out-of-bounds
    let pegOutOfBoundsA = Peg(centerX: 270, centerY: 300, color: .blue, radius: 32.0)
    let pegOutOfBoundsB = Peg(centerX: 160, centerY: 370, color: .blue, radius: 32.0)
    let pegOutOfBoundsC = Peg(centerX: 30, centerY: 200, color: .orange, radius: 32.0)
    let pegOutOfBoundsD = Peg(centerX: 200, centerY: 30, color: .orange, radius: 32.0)

    let modelName = "Test"

    var modelEmpty: Model {
        createModel(name: modelName, pegs: [])
    }
    var modelFilled: Model {
        createModel(name: modelName, pegs: [peg, pegCompatible])
    }

    func testConstr_invalidDimensions() {
        XCTAssertNil(Model(width: 0, height: 20))
        XCTAssertNil(Model(width: 30, height: 0))
        XCTAssertNil(Model(width: -1, height: 20))
        XCTAssertNil(Model(width: 30, height: -1))
        XCTAssertNotNil(Model(width: 1, height: 1))
    }

    func testConstr_noOverlappingPegs() {
        let test = modelFilled
        XCTAssertEqual(test.pegs.count, 2, "Not all pegs were added")
        XCTAssertEqual(test.levelName, modelName, "Name was incorrectly configured")
        testDimensions(of: test)
    }

    func testConstr_noPegsOrName() {
        let model = Model(width: width, height: height)
        guard let test = model else {
            XCTFail("Init should not fail")
            return
        }
        XCTAssertTrue(test.pegs.isEmpty)
        XCTAssertTrue(test.levelName.isEmpty)
        testDimensions(of: test)
    }

    func testConstr_overlappingPegs() {
        let testPegArray = [peg, pegCompatible, pegOverlap]
        let test = createModel(name: modelName, pegs: testPegArray)
        let expectedArray = [peg, pegCompatible]
        let expected = createModel(name: modelName, pegs: expectedArray)
        XCTAssertEqual(expected, test, "Second peg should not be added")
        testDimensions(of: test)
    }

    func testConstr_outOfBoundPegs() {
        var testArray = [peg, pegCompatible, pegOutOfBoundsA]
        var test = createModel(name: modelName, pegs: testArray)
        XCTAssertEqual(modelFilled, test)

        testArray = [peg, pegCompatible, pegOutOfBoundsB]
        test = createModel(name: modelName, pegs: testArray)
        XCTAssertEqual(modelFilled, test)

        testArray = [peg, pegCompatible, pegOutOfBoundsC]
        test = createModel(name: modelName, pegs: testArray)
        XCTAssertEqual(modelFilled, test)

        testArray = [peg, pegCompatible, pegOutOfBoundsD]
        test = createModel(name: modelName, pegs: testArray)
        XCTAssertEqual(modelFilled, test)
    }

    private func testDimensions(of model: Model) {
        XCTAssertEqual(model.width, width)
        XCTAssertEqual(model.height, height)
    }

    func testContains_empty_returnsFalse() {
        let test = modelEmpty
        XCTAssertFalse(test.contains(peg))
    }

    func testContains_containsPeg_returnsTrue() {
        let test = modelFilled
        XCTAssertTrue(test.contains(peg))
        XCTAssertTrue(test.contains(pegCompatible))
    }

    func testContains_pegAbsent_returnsFalse() {
        let test = modelFilled
        XCTAssertFalse(test.contains(pegOverlap))
    }

    func testInsert_empty_success() {
        var test = modelEmpty
        test.insert(peg: peg)
        XCTAssertEqual(test.pegs.count, 1, "Peg was not added")
        XCTAssertTrue(test.contains(peg))

    }

    func testInsert_newElementDoesNotClash_success() {
        var test = modelFilled
        test.insert(peg: pegCompatible2)
        XCTAssertEqual(test.pegs.count, 3)
        XCTAssertTrue(test.contains(pegCompatible2))
    }

    func testInsert_newElementClashes_pegNotAdded() {
        var test = modelFilled
        test.insert(peg: pegOverlap)
        XCTAssertEqual(test.pegs.count, 2, "Peg should not be added")
        XCTAssertFalse(test.contains(pegCompatible2))
    }

    func testInsert_newElementCrossesBorder_pegNotAdded() {
        var test = modelFilled
        test.insert(peg: pegOutOfBoundsA)
        XCTAssertEqual(test.pegs.count, 2, "Peg should not be added")
        XCTAssertFalse(test.contains(pegOutOfBoundsA))
    }

    func testDelete_pegPresent_pegDeleted() {
        var test = modelFilled

        test.delete(peg: peg)
        let expected = createModel(name: modelName, pegs: [pegCompatible])
        XCTAssertEqual(expected, test)

        test.delete(peg: pegCompatible)
        XCTAssertEqual(modelEmpty, test)
    }

    func testDelete_pegAbsent_noChange() {
        var test = modelFilled
        test.delete(peg: pegOverlap)
        XCTAssertEqual(modelFilled, test)

        test = modelEmpty
        test.delete(peg: pegCompatible)
        XCTAssertEqual(test, modelEmpty)

    }

    func testReplace_newPegClashes_noChange() {
        var test = modelFilled
        test.replace(pegCompatible, with: pegOverlap)
        XCTAssertEqual(test, modelFilled)
    }

    func testReplace_replacedAbsent_noChange() {
        var test = modelEmpty
        test.replace(pegCompatible, with: peg)
        XCTAssertEqual(test, modelEmpty)

        test = modelFilled
        test.replace(pegOverlap, with: pegCompatible2)
        XCTAssertEqual(test, modelFilled)
        XCTAssertFalse(test.contains(pegOverlap))
    }

    func testReplace_validReplacementPresentReplaced_success() {
        var test = modelFilled
        test.replace(peg, with: pegOverlap)

        let pegs = [pegOverlap, pegCompatible]
        let expected = createModel(name: modelName, pegs: pegs)
        XCTAssertEqual(expected, test)
    }

    func testReplace_replaceWithSelf_noChange() {
        var test = modelFilled
        test.replace(peg, with: peg)
        XCTAssertEqual(test, modelFilled)
    }

    func testRemoveAll() {
        var test = modelFilled
        test.removeAll()
        XCTAssertEqual(modelEmpty, test)

        test = modelEmpty
        test.removeAll()
        XCTAssertEqual(modelEmpty, test)
    }

    func testCanAccomodate() {
        let model = Model(width: width, height: height)
        guard var test = model else {
            XCTFail("Init should not fail")
            return
        }

        XCTAssertTrue(test.canAccommodate(object: peg))

        test.insert(peg: peg)
        XCTAssertFalse(test.canAccommodate(object: peg))
        XCTAssertFalse(test.canAccommodate(object: pegOverlap))
        XCTAssertTrue(test.canAccommodate(object: pegCompatible))

        test.insert(peg: pegCompatible)
        XCTAssertTrue(test.canAccommodate(object: pegCompatible2))
    }

    func testCanAccommodate_borderCheck() {
        let test = modelEmpty
        XCTAssertFalse(test.canAccommodate(object: pegOutOfBoundsA))
        XCTAssertFalse(test.canAccommodate(object: pegOutOfBoundsB))
        XCTAssertFalse(test.canAccommodate(object: pegOutOfBoundsC))
        XCTAssertFalse(test.canAccommodate(object: pegOutOfBoundsD))
    }

    func testCanAccomodate_excludingPeg() {
        let test = modelFilled
        XCTAssertFalse(test.canAccommodate(pegOverlap, excluding: pegCompatible))
        XCTAssertTrue(test.canAccommodate(pegOverlap, excluding: peg))

        XCTAssertFalse(test.canAccommodate(pegOverlap, excluding: pegOverlap))
        XCTAssertTrue(test.canAccommodate(pegCompatible2, excluding: pegOverlap))

        XCTAssertFalse(test.canAccommodate(pegOutOfBoundsA, excluding: peg))
        XCTAssertFalse(test.canAccommodate(pegOutOfBoundsB, excluding: peg))
        XCTAssertFalse(test.canAccommodate(pegOutOfBoundsC, excluding: peg))
        XCTAssertFalse(test.canAccommodate(pegOutOfBoundsD, excluding: peg))
    }

    func testFitsOnBoard() {
        let test = modelEmpty
        XCTAssertTrue(test.fitsOnBoard(object: peg))
        XCTAssertTrue(test.fitsOnBoard(object: pegOverlap))
        XCTAssertTrue(test.fitsOnBoard(object: pegCompatible))
        XCTAssertTrue(test.fitsOnBoard(object: pegCompatible2))

        XCTAssertFalse(test.fitsOnBoard(object: pegOutOfBoundsA))
        XCTAssertFalse(test.fitsOnBoard(object: pegOutOfBoundsB))
        XCTAssertFalse(test.fitsOnBoard(object: pegOutOfBoundsC))
        XCTAssertFalse(test.fitsOnBoard(object: pegOutOfBoundsD))
    }

    func testFirst_containsPegs() {
        var predicate = { (_: Peg) in true }
        let test = modelFilled
        var result = test.firstPeg(where: predicate)
        XCTAssertTrue(peg == result || pegCompatible == result)

        let testPeg = Peg(centerX: 100, centerY: 70, color: .orange)
        predicate = { (peg: Peg) in peg.overlapsWith(other: testPeg) }
        result = test.firstPeg(where: predicate)
        XCTAssertEqual(pegCompatible, result)
    }

    func testFirst_empty_returnsNil() {
        let test = modelEmpty
        let predicate = { (_: Peg) in true }
        XCTAssertNil(test.firstPeg(where: predicate))
    }

    func testFirst_pegNotPresent_returnsNil() {
        let test = modelFilled
        let predicate = { (_: Peg) in false }
        XCTAssertNil(test.firstPeg(where: predicate))
    }

    private func createModel(name: String, pegs: [Peg]) -> Model {
        guard
            let model = Model(name: name, pegs: pegs, blocks: [], width: width, height: height)
        else {
            XCTFail("Model init should not fail")
            fatalError("This should never be reached")
        }
        return model
    }
}
