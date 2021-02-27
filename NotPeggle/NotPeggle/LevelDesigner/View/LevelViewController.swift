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
    @IBOutlet private var buttonDeletePeg: UIButton!
    @IBOutlet private var buttonBlock: UIButton!
    private var buttons: [UIButton] {
        [buttonBluePeg, buttonOrangePeg, buttonDeletePeg, buttonBlock]
    }

    @IBOutlet private var pegBoard: UIView!

    @IBOutlet private var levelNameField: UITextField!
    @IBOutlet private var saveButton: UIButton!

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

    @IBAction private func setBlockMode(_ sender: UIButton) {
        mode = .addBlock
        deselectAllButtonsExcept(sender)
    }

    private func deselectAllButtonsExcept(_ sender: UIButton) {
        sender.isSelected = true
        buttons.filter { $0 !== sender }.forEach { $0.isSelected = false }
    }

    // ============== //
    // MARK: Gestures
    // ============== //

    /// Detects a tap on the peg board and either creates or deletes a peg centered on the location of the tap.
    @IBAction private func managePegsOnBoard(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: pegBoard)
        switch mode {
        case .addBlue:
            addNewPeg(color: .blue, at: location)
        case .addOrange:
            addNewPeg(color: .orange, at: location)
        case .delete:
            deletePeg(at: location)
        case .addBlock:
            addBlock(at: location)
        case .none:
            fatalError("View Controller should always load with a mode")
        }
    }

    func addNewPeg(color: Color, at location: CGPoint) {
        let peg = Converter.pegFromCGPoint(color: color, at: location)
        model.insert(peg: peg)
    }

    func deletePeg(at location: CGPoint) {
        let coordinates = Converter.pointFromCGPoint(point: location)
        let pegtoRemove = model.firstPeg(where: { $0.contains(point: coordinates) })
        let blocktoRemove = model.firstBlock(where: { $0.contains(point: coordinates) })
        if let deletedPeg = pegtoRemove {
            model.delete(peg: deletedPeg)
        } else if let deletedBlock = blocktoRemove {
            model.delete(block: deletedBlock)
        }
    }

    func addBlock(at location: CGPoint) {
        let block = Block(center: Converter.pointFromCGPoint(point: location))
        model.insert(block: block)
    }

    // ================================ //
    // MARK: Level Object View Handlers
    // ================================ //

    /// Deletes a peg from data after a long press has been applied to and refreshes UI to show the deletion.
    func holdToDeletePeg(_ gesture: UILongPressGestureRecognizer) {
        guard let view = gesture.view as? PegView else {
            fatalError("Gesture should target a PegView")
        }
        let peg = Converter.pegFromView(view)
        model.delete(peg: peg)
    }

    /// Drags a peg to a position that does not clash with pegs and saves its position.
    func dragPeg(_ gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view as? PegView else {
            fatalError("Gesture should be attached to a PegView")
        }
        let peg = Converter.pegFromView(view)
        let location = gesture.location(in: pegBoard)
        let newCenter = Converter.pointFromCGPoint(point: location)
        let newPeg = peg.recenterTo(newCenter)

        if model.canAccommodate(newPeg, excluding: peg) {
            view.center = location
            model.replace(peg, with: newPeg)
        }
    }

    /// Deletes a peg from data after a long press has been applied to and refreshes UI to show the deletion.
    func holdToDeleteBlock(_ gesture: UILongPressGestureRecognizer) {
        guard let view = gesture.view as? BlockView else {
            fatalError("Gesture should target a PegView")
        }
        let block = Converter.blockFromView(view)
        model.delete(block: block)
    }

    /// Drags a peg to a position that does not clash with pegs and saves its position.
    func dragBlock(_ gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view as? BlockView else {
            fatalError("Gesture should be attached to a PegView")
        }
        let block = Converter.blockFromView(view)
        let location = gesture.location(in: pegBoard)
        let newCenter = Converter.pointFromCGPoint(point: location)
        let newBlock = block.recenterTo(newCenter)

        if model.canAccommodate(newBlock, excluding: block) {
            view.center = location
            model.replace(block, with: newBlock)
        }
    }

    func rotateBlock(_ gesture: UIRotationGestureRecognizer) {
        guard let view = gesture.view as? BlockView else {
            fatalError("Gesture should be attached to a BlockView")
        }
        let block = Converter.blockFromView(view)
        let angle = gesture.rotation
        let newBlock = block.rotate(angle: angle.native)

        if model.canAccommodate(newBlock, excluding: block) {
            print(angle)
            view.rotate(to: angle)
            model.replace(block, with: newBlock)
        }
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
        game.initializeWithData(board: pegBoard, navController: nav, pegs: model)
        navigationController?.pushViewController(game, animated: false)
    }

    /// Allows users to stop editing by tapping anywhere outside the level name text field.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}

enum Mode {
    case addBlue, addOrange, delete, addBlock
}
