//
//  StorageTests.swift
//  NotPeggleTests
//
//  Created by Ying Gao on 29/1/21.
//

import XCTest
@testable import NotPeggle

class StorageTests: XCTestCase {

    // MARK: Empty Model Case
    let levelNameEmpty = "empty model"
    var emptyModel: Model {
        return createModel(name: levelNameEmpty, pegs: [])
    }
    var emptyModelJSON: Data! {
        return try? Storage.encoder.encode(emptyModel)
    }

    // MARK: Populated Model Case
    let levelNameWithValues = "populated model"
    let peg1 = Peg(centerX: 32, centerY: 32, color: .blue)
    let peg2 = Peg(centerX: 106, centerY: 200, color: .orange)
    var modelWithValues: Model {
        return createModel(name: levelNameWithValues, pegs: [peg1, peg2])
    }
    var modelWithValuesJSON: Data! {
        return try? Storage.encoder.encode(modelWithValues)
    }

    // MARK: Invalid Cases
    let unnamedModel = Model(width: 300, height: 400)
    var unnamedModelJSON: Data! {
        return try? Storage.encoder.encode(unnamedModel)
    }
    let invalidString = "{\n  \"invalidField\" : [\n\n  ],\n  \"levelName\" : \"empty model\"\n}"
    var invalidJSON: Data! {
        return invalidString.data(using: .utf8)!
    }

    // MARK: Tests
    func testDecode_invalidData_returnNil() {
        XCTAssertNil(Storage.decode(data: invalidJSON))
    }

    func testDecode_emptyModel_success() {
        let result = Storage.decode(data: emptyModelJSON)
        XCTAssertEqual(emptyModel, result)
    }

    func testDecode_populatedModel_success() {
        let result = Storage.decode(data: modelWithValuesJSON)
        XCTAssertEqual(modelWithValues, result)
    }

    func testDelete_fileExists_success() {
        let fileToDelete = "delete this"
        let url = Storage.getFileURL(from: fileToDelete, with: Storage.fileExtension)
        try? invalidJSON.write(to: url)
        XCTAssertTrue(Storage.saves.contains(fileToDelete))

        XCTAssertNoThrow(try Storage.deleteSave(name: fileToDelete))
        XCTAssertFalse(Storage.saves.contains(fileToDelete))
    }

    func testDelete_fileNotFound_error() {
        let randomFileName = "nothing here"
        XCTAssertThrowsError(try Storage.deleteSave(name: randomFileName))
    }

    func testSaveToDisk_namedModels_success() {
        XCTAssertNoThrow(try Storage.saveToDisk(model: emptyModel))
        XCTAssertTrue(Storage.saves.contains(levelNameEmpty))

        XCTAssertNoThrow(try Storage.saveToDisk(model: modelWithValues))
        XCTAssertTrue(Storage.saves.contains(levelNameWithValues))
    }

    func testSaveToDisk_unnamedModel_error() {
        guard let test = unnamedModel else {
            XCTFail("Init should not fail")
            return
        }
        XCTAssertThrowsError(try Storage.saveToDisk(model: test))
    }

    func testLoadModel_validFile_success() {
        XCTAssertNoThrow(try Storage.saveToDisk(model: emptyModel))
        XCTAssertNoThrow(try Storage.loadModel(name: levelNameEmpty))
        let modelLoaded = try? Storage.loadModel(name: levelNameEmpty)
        XCTAssertEqual(modelLoaded, emptyModel)
    }

    func testLoadModel_fileNotFound_error() {
        XCTAssertThrowsError(try Storage.loadModel(name: levelNameEmpty))
    }

    func testLoadModel_fileIsNotModel_returnNil() {
        let fileToLoad = "invalid file"
        let url = Storage.getFileURL(from: fileToLoad, with: Storage.fileExtension)
        try? invalidJSON.write(to: url)

        XCTAssertNil(try Storage.loadModel(name: fileToLoad))
    }

    func testLoadModel_unnamedModel_error() {
        let fileToLoad = "unnamed model"
        let url = Storage.getFileURL(from: fileToLoad, with: Storage.fileExtension)
        try? unnamedModelJSON.write(to: url)

        XCTAssertThrowsError(try Storage.loadModel(name: fileToLoad))
    }

    override func tearDownWithError() throws {
        for save in Storage.saves {
            try? Storage.deleteSave(name: save)
        }
    }

    private func createModel(name: String, pegs: [Peg]) -> Model {
        guard
            let model = Model(name: name, pegs: pegs, width: 300, height: 400)
        else {
            XCTFail("Model init should not fail")
            fatalError("This should never be reached")
        }
        return model
    }

}
