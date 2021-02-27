//
//  LevelViewController.swift
//  NotPeggle
//
//  Created by Ying Gao on 19/1/21.
//

import UIKit

class LevelViewController: UIViewController, UITextFieldDelegate, PegViewDelegate, BlockViewDelegate {

    typealias Converter = ModelViewConverter

    var model: Model! {
        didSet {
            refreshUIWithChanges()
        }
    }
    var mode: Mode!

    // MARK: Properties

    @IBOutlet private var buttonBluePeg: UIButton!
    @IBOutlet private var buttonOrangePeg: UIButton!
    @IBOutlet private var buttonGreenPeg: UIButton!
    @IBOutlet private var buttonBlock: UIButton!
    @IBOutlet private var buttonDeletePeg: UIButton!
    private var buttons: [UIButton] {
        [buttonBluePeg, buttonOrangePeg, buttonDeletePeg, buttonGreenPeg, buttonBlock]
    }

    @IBOutlet private var pegBoard: UIView!

    @IBOutlet private var levelNameField: UITextField!
    @IBOutlet private var saveButton: UIButton!

    var gameArea: UIView! {
        pegBoard
    }

    // ============================== //
    // MARK: Methods for Loading View
    // ============================== //

    override func viewDidLoad() {
        super.viewDidLoad()
        mode = .addBlue
        deselectAllButtonsExcept(buttonBluePeg)
        setUpTextField()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpModelIfAbsent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    /// Initialises the model if it is not already present
    func setUpModelIfAbsent() {
        guard model == nil else {
            return
        }
        let width = pegBoard.frame.width.native
        let height = pegBoard.frame.height.native
        guard let model = Model(width: width, height: height) else {
            fatalError("Initialisation should not fail")
        }
        self.model = model
    }

    /// Updates UI with changed data from the model.
    func refreshUIWithChanges() {
        loadModelData()
        displayLevelName()
        setSaveButtonEnabledState()
    }

    /// Reloads all data from the model. Any excess pegs are deleted and missing pegs are created.
    func loadModelData() {
        deleteExtraPegViews()
        deleteExtraBlockViews()
        createMissingViews()
    }

    /// Sets the text field's delegate to the controller and fills it with the model's name it present.
    func setUpTextField() {
        levelNameField.delegate = self
        subscribeToKeyboardNotifications()
    }

    /// Observes activation of the keyboard to move the display up or down if needed.
    /// Credit: https://fluffy.es/move-view-when-keyboard-is-shown/
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func setSaveButtonEnabledState() {
        saveButton.isEnabled = !model.levelName.isEmpty
    }

    /// Sets the text within the text field to the model's name if present.
    private func displayLevelName() {
        guard !model.levelName.isEmpty else {
            return
        }
        levelNameField.text = model.levelName
    }

    /// Delete all `PegView` objects that are not in the model.
    private func deleteExtraPegViews() {
        for view in pegBoard.subviews {
            guard let pegView = view as? PegView else {
                continue
            }
            let modelPeg = Converter.pegFromView(pegView)
            if !model.contains(modelPeg) {
                view.removeFromSuperview()
            }
        }
    }

    /// Delete all `BlockView` objects that are not in the model.
    private func deleteExtraBlockViews() {
        for view in pegBoard.subviews {
            guard let blockView = view as? BlockView else {
                continue
            }
            let modelBlock = Converter.blockFromView(blockView)
            if !model.contains(modelBlock) {
                view.removeFromSuperview()
            }
        }
    }

    /// Creates `UIView` objects for `LevelObject` instances that are not represented in the UI.
    /// `LevelObject`s  that cross the borders of the game area are excluded.
    private func createMissingViews() {
        let pegViews = pegBoard.subviews
            .compactMap { $0 as? PegView }
            .map { Converter.pegFromView($0) }
        model.pegs.filter { !pegViews.contains($0) }.forEach { addNewPegView(peg: $0) }
        let blockViews = pegBoard.subviews
            .compactMap { $0 as? BlockView }
            .map { Converter.blockFromView($0) }
        model.blocks.filter { !blockViews.contains($0) }.forEach { addNewBlockView(block: $0) }
    }

    /// Creates a `PegView` for a given `Peg` if it fits within the board area.
    private func addNewPegView(peg: Peg) {
        guard model.fitsOnBoard(object: peg) else {
            return
        }
        let newPeg = Converter.viewFromPeg(peg)
        newPeg.delegate = self
        pegBoard.addSubview(newPeg)
    }

    /// Creates a `BlockView` for a given `Block` if it fits within the board area.
    private func addNewBlockView(block: Block) {
        guard model.fitsOnBoard(object: block) else {
            return
        }
        let blockView = Converter.viewFromBlock(block)
        blockView.delegate = self
        pegBoard.addSubview(blockView)
    }

    // ==================== //
    // MARK: Button Actions
    // ==================== //

    @IBAction private func setAddBlueMode(_ sender: UIButton) {
        mode = .addBlue
        deselectAllButtonsExcept(sender)
    }

    @IBAction private func setAddOrangeMode(_ sender: UIButton) {
        mode = .addOrange
        deselectAllButtonsExcept(sender)
    }

    @IBAction private func setDeleteMode(_ sender: UIButton) {
        mode = .delete
        deselectAllButtonsExcept(sender)
    }

    @IBAction private func setAddGreenMode(_ sender: UIButton) {
        mode = .addGreen
        deselectAllButtonsExcept(sender)
    }

    @IBAction private func setBlockMode(_ sender: UIButton) {
        mode = .addBlock
        deselectAllButtonsExcept(sender)
    }

    private func deselectAllButtonsExcept(_ sender: UIButton) {
        sender.isSelected = true
        buttons.filter { $0 !== sender }.forEach { $0.isSelected = false }
    }

    // =================== //
    // MARK: Load and Save
    // =================== //

    @IBAction private func resetBoard(_ sender: UIButton) {
        model.removeAll()
    }

    @IBAction private func saveLevelLayout(_ sender: UIButton) {
        do {
            try Storage.saveToDisk(model: model)
            saveButton.isEnabled = false
        } catch StorageError.unnamedFileError {
            fatalError("Save button should be disabled")
        } catch {
            print(error)
        }
    }

    /// Sets the model to the one selected in the load menu if it is a value save (i.e. `save != nil`).
    @IBAction private func unwindSaveSelection(sender: UIStoryboardSegue) {
        guard
            let source = sender.source as? SaveTableViewController,
            let newModel = source.selectedSave
        else {
            return
        }

        model = newModel
        // Since the new model hasn't been altered, users do not need to save.
        saveButton.isEnabled = false
    }

    @IBAction private func startGame(_ sender: UIButton) {
        let gameID = "gameController"
        let gameController = storyboard?.instantiateViewController(identifier: gameID) as? GameViewController
        guard let game = gameController else {
            fatalError("GameViewController identifier is invalid")
        }
        guard let nav = navigationController else {
            fatalError("VC should have a navigation controller")
        }
        game.initializeWithData(navController: nav, model: model)
        navigationController?.pushViewController(game, animated: false)
    }

    /// Allows users to stop editing by tapping anywhere outside the level name text field.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}

enum Mode {
    case addBlue, addOrange, delete, addBlock, addGreen
}
