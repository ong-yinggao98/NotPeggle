//
//  LevelFactory.swift
//  NotPeggle
//
//  Created by Ying Gao on 28/2/21.
//

import Foundation

/**
 A utility struct built above `Storage` to generate simple preloaded levels.
 These levels cannot be deleted nor overwritten even if you name the level by the same name.
 They are identifable by the "[DEFAULT]" prefix.
 Levels are only created if they cannot be found (i.e. first time start up of the app).
 */
struct LevelFactory {

    static let savePrefix = "[DEFAULT] "

    static func generatePreloadedLevels(width: Double, height: Double) {
        guard Storage.preloadedLevels.isEmpty else {
            return
        }
        generateOnePegLevel(width: width, height: height)
        generateTwoPegLevel(width: width, height: height)
        generatePegAndBlockLevel(width: width, height: height)
    }

    private static func generateOnePegLevel(width: Double, height: Double) {
        let name = "one peg"
        let peg = Peg(center: Point(x: width / 2, y: height / 2), color: .blue)
        let model = Model(name: name, pegs: [peg], blocks: [], width: width, height: height)
        let saveName = savePrefix + name
        guard let modelUnwrapped = model else {
            fatalError("Model init should not fail.")
        }
        try? Storage.saveToDisk(model: modelUnwrapped, fileName: saveName, folder: Storage.preloadedFolder)
    }

    private static func generateTwoPegLevel(width: Double, height: Double) {
        let name = "two pegs"
        let radius = 32.0
        let pegA = Peg(center: Point(x: radius, y: height - radius), color: .blue, radius: radius)
        let pegB = Peg(center: Point(x: width - radius, y: height - radius), color: .orange, radius: radius)
        let model = Model(name: name, pegs: [pegA, pegB], blocks: [], width: width, height: height)
        let saveName = savePrefix + name
        guard let modelUnwrapped = model else {
            fatalError("Model init should not fail")
        }
        try? Storage.saveToDisk(model: modelUnwrapped, fileName: saveName, folder: Storage.preloadedFolder)
    }

    private static func generatePegAndBlockLevel(width: Double, height: Double) {
        let name = "peg and block"
        let peg = Peg(center: Point(x: width / 2, y: height / 2), color: .orange)
        let block = Block(center: Point(x: Constants.blockHeight, y: height - Constants.blockHeight / 2))
        let model = Model(name: name, pegs: [peg], blocks: [block], width: width, height: height)
        let saveName = savePrefix + name
        guard let modelUnwrapped = model else {
            fatalError("Model init should not fail")
        }
        try? Storage.saveToDisk(model: modelUnwrapped, fileName: saveName, folder: Storage.preloadedFolder)
    }

}
