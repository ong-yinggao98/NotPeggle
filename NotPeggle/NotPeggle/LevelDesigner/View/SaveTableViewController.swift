//
//  SaveTableViewController.swift
//  NotPeggle
//
//  Created by Ying Gao on 29/1/21.
//

import UIKit

class SaveTableViewController: UITableViewController {

    var savedLevels: [Save] = []

    private(set) var selectedSave: Model?

    override func viewDidLoad() {
        super.viewDidLoad()
        savedLevels.append(contentsOf: Storage.preloadedLevels)
        savedLevels.append(contentsOf: Storage.userSaves)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        savedLevels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "SaveTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = savedLevels[indexPath.row].name
        return cell
    }

    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath) {

        let preloadedSaveIndices = 0..<Storage.preloadedLevels.count
        guard !preloadedSaveIndices.contains(indexPath.row) else {
            return
        }

        switch editingStyle {
        case .delete:
            deleteSaveFile(at: indexPath)
        default:
            return
        }
    }

    private func deleteSaveFile(at indexPath: IndexPath) {
        let removedSave = savedLevels[indexPath.row]
        try? removedSave.delete()
        savedLevels.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }

    /// On selection of a cell, loads the save and then returns the user to the refreshed main screen.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }

        selectSaveWith(index: indexPath.row)
        unwindSegue(sender: cell)
    }

    /// Sets the selected save `Model` to be the one loaded from the file with the same name.
    private func selectSaveWith(index: Int) {
        do {
            let saveModel = savedLevels[index]
            selectedSave = try saveModel.toModel()
        } catch StorageError.unnamedFileError {
            fatalError("There should not be unnamed cells or saves created.")
        } catch {
            return
        }
    }

    private func unwindSegue(sender: UITableViewCell) {
        let identifier = "Unwind"
        performSegue(withIdentifier: identifier, sender: sender)
    }

}
