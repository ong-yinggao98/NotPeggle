//
//  PreloadedSave.swift
//  NotPeggle
//
//  Created by Ying Gao on 28/2/21.
//

import Foundation

struct PreloadedSave: Save {

    var name: String
    var url: URL

    init(url: URL) {
        self.url = url
        self.name = url.deletingPathExtension().lastPathComponent
    }

    func toModel() throws -> Model? {
        let folder = url.deletingPathExtension().deletingLastPathComponent().lastPathComponent
        let model = try Storage.loadModel(name: name, folder: folder)
        return model
    }

    func delete() throws {
        // One should not be able to delete a Preloaded Save
    }

}
