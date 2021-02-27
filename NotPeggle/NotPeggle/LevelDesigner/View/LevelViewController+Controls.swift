//
//  LevelViewController+Controls.swift
//  NotPeggle
//
//  Created by Ying Gao on 27/2/21.
//

import UIKit

extension LevelViewController {

    // MARK: Text Field Methods

    /// Sets the text field to hide the keyboard after hitting return.
    /// Taken from Apple's Storyboard tutorial (Connect the UI to Code)
    /// https://developer.apple.com/library/archive/referencelibrary/GettingStarted/DevelopiOSAppsSwift
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    /// Sets the model's name after the user has finished typing.
    /// Taken from Apple's Storyboard tutorial (Connect the UI to Code)
    /// https://developer.apple.com/library/archive/referencelibrary/GettingStarted/DevelopiOSAppsSwift
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        guard
            let newName = textField.text,
            model.levelName != newName
        else {
            return
        }

        if !newName.contains("/") {
            model.levelName = newName
        } else {
            alertOnInvalidName()
            textField.text = model.levelName
        }
    }

    private func alertOnInvalidName() {
        let alert = UIAlertController(
            title: "Invalid name!",
            message: "Level titles should not have \"/\" characters.\nPlease try again",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    /// Moves the display up to show the user what they have added into the text field.
    /// Credit: https://fluffy.es/move-view-when-keyboard-is-shown/
    @objc func keyboardWillShow(notification: NSNotification) {
        guard
            let userInfo = notification.userInfo,
            let keyBoardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else {
           return
        }
        let keyboardSize = keyBoardFrame.cgRectValue
        view.frame.origin.y = 0 - keyboardSize.height
    }

    /// Moves the display back down when no longer needed.
    /// Credit: https://fluffy.es/move-view-when-keyboard-is-shown/
    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }

}
