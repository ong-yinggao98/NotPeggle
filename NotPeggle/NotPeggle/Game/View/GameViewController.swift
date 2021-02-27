//
//  GameViewController.swift
//  NotPeggle
//
//  Created by Ying Gao on 12/2/21.
//

import UIKit

class GameViewController: UIViewController, GameEngineDelegate {

    // MARK: Properties
    var gameArea: UIImageView!
    var engine: GameEngine!
    var cannon: CannonView!

    private var cannonBallSprite: CannonBallView?

    weak var navController: UINavigationController?

    // ==================== //
    // MARK: Set-up Actions
    // ==================== //

    /// Initialises the game area and engine from the data given.
    /// This method **must** be called by the previous view controller before pushing this to the stack.
    func initializeWithData(board: UIView, navController: UINavigationController, pegs: Model) {
        modalPresentationStyle = .fullScreen
        setGameArea(board: board)
        setUpGestureRecognizer()
        self.navController = navController
        initializeEngineAndLoadView(model: pegs)
        createDisplayLink()
    }

    func setGameArea(board: UIView) {
        setBackgroundFrom(board)
        gameArea.isUserInteractionEnabled = true
        gameArea.clipsToBounds = true
        view.addSubview(gameArea!)
    }

    private func setBackgroundFrom(_ view: UIView) {
        let background = UIImageView(image: #imageLiteral(resourceName: "background"))
        background.frame = view.frame
        background.contentMode = .scaleAspectFill
        gameArea = background
    }

    func setUpGestureRecognizer() {
        let panGestureRecognizer = UIPanGestureRecognizer(
            target: self,
            action: #selector(willLaunchCannon(_:))
        )
        gameArea.addGestureRecognizer(panGestureRecognizer)
    }

    func initializeEngineAndLoadView(model: Model) {
        engine = ModelGameConverter.gameRepresentation(model: model, delegate: self)
        showCannon()
        viewDidAppear(false)
    }

    func createDisplayLink() {
        let displayLink = CADisplayLink(target: self, selector: #selector(refreshView))
        displayLink.add(to: .current, forMode: .default)
    }

    @objc func refreshView(displayLink: CADisplayLink) {
        let elapsed = displayLink.targetTimestamp - displayLink.timestamp
        engine?.refresh(elapsed: elapsed)
    }

    // MARK: Cannon Functionality

    @objc func willLaunchCannon(_ gestureRecognizer: UIPanGestureRecognizer) {
        let location = gestureRecognizer.location(in: gameArea)
        cannon.rotate(facing: location)
        engine.aim(at: location)
    }

    func showCannon() {
        cannon = CannonView(launchPosition: engine.launchPoint)
        gameArea.addSubview(cannon)
    }

    func rotateCannon(towards position: CGPoint) {
        cannon.rotate(facing: position)
    }

    @IBAction private func didLaunchCannon(_ sender: UIButton) {
        engine.launch()
    }

    // ========== //
    // MARK: Quit
    // ========== //

    @IBAction private func returnToNotPeggle(_ sender: Any) {
        navController?.popViewController(animated: false)
        engine.cleanUp()
        gameArea.subviews
            .compactMap { $0 as? GamePegView }
            .forEach { $0.removeFromSuperview() }
    }

    private func cleanUp() {
        engine.cleanUp()
        gameArea.subviews
            .compactMap { $0 as? GamePegView }
            .forEach { $0.removeFromSuperview() }
    }

    // ==================== //
    // MARK: Sprite Updates
    // ==================== //

    func updateCannonBallPosition() {
        if let cannonBallView = cannonBallSprite {
            cannonBallView.removeFromSuperview()
            cannonBallSprite = nil
        }
        guard let cannonBall = engine.cannon else {
            return
        }
        let cannonBallView = CannonBallView(center: cannonBall.center)
        cannonBallSprite = cannonBallView
        gameArea.insertSubview(cannonBallView, belowSubview: cannon)
    }

    /// Hides highlighted pegs after the ball has left the screen.
    func deleteExtraPegs() {
        let pegsToRemove = gameArea.subviews
            .compactMap { $0 as? GamePegView }
            .filter { peg in
                guard let gamePeg = GamePeg(pegColor: peg.color, pos: peg.center, radius: peg.radius) else {
                    fatalError("Game Peg should not have been created with failed init")
                }
                return !engine.gamePegs.contains(gamePeg)
            }
        UIView.animate(
            withDuration: 0.2,
            animations: { pegsToRemove.forEach { $0.makeTransparent() } }
        )
    }

    func addMissingObjects(pegs: [GamePeg], blocks: [GameBlock]) {
        addMissingPegs(pegs: pegs)
        addMissingBlocks(blocks: blocks)
    }

    private func addMissingPegs(pegs: [GamePeg]) {
        pegs.map { GamePegView(radius: $0.radius, center: $0.center, color: $0.color) }
            .filter { !gameArea.subviews.contains($0) }
            .forEach { gameArea.addSubview($0) }
    }

    private func addMissingBlocks(blocks: [GameBlock]) {
        blocks.map { GameBlockView(center: $0.center, width: $0.width, height: $0.height, angle: $0.angle) }
            .filter { !gameArea.subviews.contains($0) }
            .forEach { gameArea.addSubview($0) }
    }

    func removeView(of peg: GamePeg) {
        let pegViews = gameArea.subviews.compactMap { $0 as? GamePegView }
        let toRemove = pegViews.first(where: { $0.center == peg.center && $0.color == peg.color })
        UIView.animate(withDuration: 0.2, animations: { toRemove?.makeTransparent() })
    }

    /// Sets hit pegs to their highlighted forms.
    func highlightPegs() {
        let pegViews = gameArea.subviews.compactMap { $0 as? GamePegView }
        for peg in engine.gamePegs where peg.hit {
            let highlighted = pegViews.first(where: { $0.center == peg.center && $0.color == peg.color })
            highlighted?.highlight()
        }
    }

}
