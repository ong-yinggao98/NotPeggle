//
//  UserSave.swift
//  NotPeggle
//
//  Created by Ying Gao on 28/2/21.
//

import Foundation

struct UserSave: Save {

    var name: String
    var url: URL

    init(url: URL) {
        self.url = url
        self.name = url.deletingPathExtension().lastPathComponent
    }

    func toModel() throws -> Model? {
        try Storage.loadModel(name: name)
    }

    func delete() throws {
        try Storage.deleteSave(name: name)
    }

}
