//
//  Storage.swift
//  NotPeggle
//
//  Created by Ying Gao on 27/1/21.
//

import Foundation

/**
 Storage utility struct that supports operations for managing saved levels.
 Models are stored as JSON files in the application directory.
 It supports operations for saving models, retrieving models and deleting models.
 */
struct Storage {

    static let preloadedFolder = "Preloaded"
    static var fileExtension = "json"

    static var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }

    /// Saves a model to a JSON file named after it.
    /// If the model is unnamed, the method throws an error.
    static func saveToDisk(model: Model, fileName: String) throws {
        guard !fileName.isEmpty else {
            throw StorageError.unnamedFileError
        }

        let url = getFileURL(from: fileName, with: fileExtension)
        let data = try? encoder.encode(model)
        try data?.write(to: url)
    }

    static func saveToDisk(model: Model, fileName: String, folder: String) throws {
        guard !fileName.isEmpty else {
            throw StorageError.unnamedFileError
        }

        let url = getFileURL(from: fileName, in: folder, with: fileExtension)
        let data = try? encoder.encode(model)
        try data?.write(to: url)
    }

    /// Loads a model from a JSON file with the given `name`.
    /// If the file URL is invalid, the method throws an error.
    /// If the saved data cannot be converted to a `Model`, or the model is unnamed, returns nil.
    static func loadModel(name: String) throws -> Model? {
        let url = getFileURL(from: name, with: Storage.fileExtension)
        let savedModel = try Data(contentsOf: url)
        guard let model = decode(data: savedModel) else {
            return nil
        }
        guard !model.levelName.isEmpty else {
            throw StorageError.unnamedFileError
        }
        return model

    }

    /// Loads a model from a JSON file with the given `name`.
    /// If the file URL is invalid, the method throws an error.
    /// If the saved data cannot be converted to a `Model`, or the model is unnamed, returns nil.
    static func loadModel(name: String, folder: String) throws -> Model? {
        let url = getFileURL(from: name, in: folder, with: fileExtension)
        let savedModel = try Data(contentsOf: url)
        guard let model = decode(data: savedModel) else {
            return nil
        }
        guard !model.levelName.isEmpty else {
            throw StorageError.unnamedFileError
        }
        return model
    }

    /// Decodes the contents of a JSON file into the corresponding `Model` instance.
    /// Returns nil if the data cannot be converted to a `Model`.
    static func decode(data: Data) -> Model? {
        let decoder = JSONDecoder()
        do {
            let model = try decoder.decode(Model.self, from: data)
            return model
        } catch {
            print(error)
            return nil
        }
    }

    /// Deletes an unneeded save file.
    /// If the file does not exist, the method throws an error.
    static func deleteSave(name: String) throws {
        let deletedURL = getFileURL(from: name, with: Storage.fileExtension)
        try FileManager.default.removeItem(at: deletedURL)
    }

    /// Deletes an unneeded save file.
    /// If the file does not exist, the method throws an error.
    static func deleteSave(name: String, folder: String) throws {
        let deletedURL = getFileURL(from: name, in: folder, with: Storage.fileExtension)
        try FileManager.default.removeItem(at: deletedURL)
    }

    /// A list of names of all saved models in the application directory.
    static var saves: [Save] {
        var saves: [Save] = []
        saves.append(contentsOf: preloadedLevels)
        saves.append(contentsOf: userSaves)
        return saves
    }

    static var userSaves: [UserSave] {
        let directory = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURLs = getFileURLs(in: directory)
        return fileURLs
            .filter { $0.pathExtension == fileExtension }
            .map { UserSave(url: $0) }
    }

    static var preloadedLevels: [PreloadedSave] {
        let directory = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(preloadedFolder)
        let fileURLs = getFileURLs(in: directory)
        return fileURLs
            .filter { $0.pathExtension == fileExtension }
            .map { PreloadedSave(url: $0) }
    }

    /// Retrieves all file URLs in the application directory.
    static func getFileURLs(in directory: URL) -> [URL] {
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: false)
        let filesFound = try? FileManager.default.contentsOfDirectory(
            at: directory,
            includingPropertiesForKeys: nil,
            options: [.skipsSubdirectoryDescendants, .skipsHiddenFiles]
        )
        return filesFound ?? []
    }

    /// Retrieves the full URL of a file to be read, deleted or written to.
    static func getFileURL(from name: String, with extensionType: String) -> URL {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return directory.appendingPathComponent(name).appendingPathExtension(extensionType)
    }

    static func getFileURL(from name: String, in folderName: String, with extensionType: String) -> URL {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let withFolder = directory.appendingPathComponent(folderName)
        return withFolder.appendingPathComponent(name).appendingPathExtension(extensionType)
    }
}

/**
 A recoverable error that is thrown when attempting to save an unnamed model.
 */
enum StorageError: Error {
    case unnamedFileError
}
