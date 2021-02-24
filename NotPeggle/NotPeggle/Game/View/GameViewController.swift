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

    weak var navController: UINavigationController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: Set-up Actions

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
        for child in board.subviews {
            guard let image = child as? UIImageView else {
                continue
            }
            setBackgroundFrom(image)
        }
        gameArea.isUserInteractionEnabled = true
        view.addSubview(gameArea!)
    }

    private func setBackgroundFrom(_ imageView: UIImageView) {
        let background = UIImageView(image: imageView.image)
        background.frame = imageView.frame
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
        engine = ModelGameConverter.gameRepresentation(model: model)
        engine.observer = self
        showCannon()
        updateSprites()
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

    @IBAction func didLaunchCannon(_ sender: UIButton) {
        engine.launch()
    }

    // MARK: Quit

    @IBAction func returnToNotPeggle(_ sender: Any) {
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

    // MARK: Sprite Updates

    /// Updates the location and status of all cannon and pegs in the game.
    func updateSprites() {
        updateCannonBallPosition()
        updatePegSprites()
    }

    func updateCannonBallPosition() {
        for child in gameArea.subviews where child is CannonBallView {
            child.removeFromSuperview()
        }
        guard let cannonBall = engine.cannon else {
            return
        }
        let cannonBallView = CannonBallView(center: cannonBall.center)
        gameArea.insertSubview(cannonBallView, belowSubview: cannon)
    }

    func updatePegSprites() {
        deleteExtraPegs()
        addMissingPegs()
        highlightPegs()
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

    func addMissingPegs() {
        engine.gamePegs
            .map { GamePegView(radius: $0.radius, center: $0.center, color: $0.color) }
            .filter { !gameArea.subviews.contains($0) }
            .forEach { gameArea.addSubview($0) }
    }

    /// Sets hit pegs to their highlighted forms.
    func highlightPegs() {
        let pegViews = gameArea.subviews.compactMap { $0 as? GamePegView }
        for peg in engine.gamePegs where peg.hit {
            pegViews
                .first(where: { $0.center == peg.center && $0.color == peg.color })?
                .highlight()
        }
    }

}
