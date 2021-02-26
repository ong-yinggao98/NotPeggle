//
//  ModelTests+Blocks.swift
//  NotPeggleTests
//
//  Created by Ying Gao on 26/2/21.
//

import XCTest
@testable import NotPeggle

extension ModelTests {

    var blockA: Block {
        Block(center: Point(x: 100, y: 100), height: 30)
    }
    var blockB: Block {
        Block(center: Point(x: 200, y: 130), height: 30)
    }
    var blockC: Block {
        Block(center: Point(x: 60, y: 60), height: 30)
    }
    var blockD: Block {
        Block(center: Point(x: 110, y: 90), height: 30)
    }

    var blockOOB: Block {
        Block(center: Point(x: 0, y: 0), height: 30)
    }

    var modelBlocks: Model {
        createModel(name: modelName, blocks: [blockA, blockB])
    }

    func testInsertBlocks_emptyModel_success() {
        var testCase = modelEmpty
        testCase.insert(block: blockA)
        XCTAssertEqual(testCase.blocks.count, 1)
        XCTAssertTrue(testCase.contains(blockA))
    }

    func testInsertBlocks_noClashingBlocks_success() {
        var testCase = modelBlocks
        testCase.insert(block: blockC)
        XCTAssertEqual(testCase.blocks.count, 3)
        XCTAssertTrue(testCase.contains(blockC))
    }

    func testInsertBlocks_clashingBlocks_fail() {
        var testCase = modelBlocks
        testCase.insert(block: blockA)
        XCTAssertEqual(testCase.blocks.count, 2)
        XCTAssertTrue(testCase.contains(blockA))

        testCase.insert(block: blockD)
        XCTAssertEqual(testCase.blocks.count, 2)
        XCTAssertFalse(testCase.contains(blockD))
    }

    func testInsertBlocks_outOfBounds_fail() {
        var testCase = modelBlocks
        testCase.insert(block: blockOOB)
        XCTAssertEqual(testCase.blocks.count, 2)
        XCTAssertFalse(testCase.contains(blockOOB))
    }

    func testDeleteBlocks_emptyModel_noChange() {
        var testCase = modelEmpty
        testCase.delete(block: blockA)
        XCTAssertTrue(testCase.blocks.isEmpty)
    }

    func testDeleteBlocks_blockFound_deleted() {
        var testCase = modelBlocks
        testCase.delete(block: blockA)
        XCTAssertFalse(testCase.contains(blockA))
        XCTAssertEqual(testCase.blocks.count, 1)
    }

    func testReplaceBlock_blockCompatible_success() {
        var testCase = modelBlocks
        testCase.replace(blockA, with: blockD)
        XCTAssertFalse(testCase.contains(blockA))
        XCTAssertTrue(testCase.contains(blockD))
    }

    func testReplaceBlock_blockAbsent_fail() {
        var testCase = modelBlocks
        testCase.delete(block: blockA)
        testCase.replace(blockA, with: blockC)
        XCTAssertFalse(testCase.contains(blockC))
    }

    func testReplaceBlock_blockClashes_fail() {
        var testCase = modelBlocks
        testCase.replace(blockB, with: blockD)
        XCTAssertFalse(testCase.contains(blockD))
        XCTAssertTrue(testCase.contains(blockB))
    }

    func testReplaceBlock_blockOOB_fail() {
        var testCase = modelBlocks
        testCase.replace(blockA, with: blockOOB)
        XCTAssertFalse(testCase.contains(blockOOB))
        XCTAssertTrue(testCase.contains(blockA))
    }

    private func createModel(name: String, blocks: [Block]) -> Model {
        guard
            let model = Model(name: name, pegs: [], blocks: blocks, width: width, height: height)
        else {
            XCTFail("Model init should not fail")
            fatalError("This should never be reached")
        }
        return model
    }
}
