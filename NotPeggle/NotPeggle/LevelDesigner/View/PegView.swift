//
//  DraggableImageView.swift
//  NotPeggle
//
//  Created by Ying Gao on 26/1/21.
//

import UIKit

/**
 View representation of a `Peg`.
 It comprises a `UIImageView` that displays its color, as well as
 gesture recognizers for dragging and deletion.
 */
class PegView: UIView {

    // MARK: Static variables
    static let radius = CGFloat(Constants.pegRadius)

    static var bluePeg: UIImageView! {
        let image = UIImage(named: "blue-bubble")
        return UIImageView(image: image)
    }
    static var orangePeg: UIImageView! {
        let image = UIImage(named: "orange-bubble")
        return UIImageView(image: image)
    }

    static var frameSize: CGSize {
        let diameter = 2 * radius
        return CGSize(width: diameter, height: diameter)
    }

    // MARK: Instance variables
    let color: Color
    weak var delegate: PegViewDelegate!

    // MARK: Initialisers
    init(center: CGPoint, color: Color) {
        let frame = PegView.createFrameFrom(center)
        self.color = color
        super.init(frame: frame)

        setImageBasedOnColor()

        isUserInteractionEnabled = true
        setUpGestureRecognition()
    }

    required init?(coder: NSCoder) {
        fatalError("This class should not be created in a Storyboard")
    }

    // MARK: Methods
    private static func createFrameFrom(_ center: CGPoint) -> CGRect {
        let origin = createOriginFrom(center)
        return CGRect(origin: origin, size: frameSize)
    }

    private static func createOriginFrom(_ center: CGPoint) -> CGPoint {
        let xOrigin = center.x - radius
        let yOrigin = center.y - radius
        return CGPoint(x: xOrigin, y: yOrigin)
    }

    // MARK: Image setting
    private func setImageBasedOnColor() {
        guard subviews.isEmpty else {
            return
        }

        let imageView = rawImageViewForSubview()
        imageView.frame = bounds
        addSubview(imageView)
    }

    private func rawImageViewForSubview() -> UIImageView {
        switch color {
        case .blue:
            return PegView.bluePeg
        case .orange:
            return PegView.orangePeg
        }
    }

    // MARK: Gesture recognition
    func setUpGestureRecognition() {
        setUpPanRecognition()
        setUpLongPressRecognition()
    }

    func setUpPanRecognition() {
        let panGestureRecognizer = UIPanGestureRecognizer(
            target: self,
            action: #selector(dragView(gesture:))
        )
        addGestureRecognizer(panGestureRecognizer)
    }

    @objc func dragView(gesture: UIPanGestureRecognizer) {
        delegate.dragPeg(gesture)
    }

    func setUpLongPressRecognition() {
        let holdGestureRecognizer = UILongPressGestureRecognizer(
            target: self,
            action: #selector(deleteView(gesture:))
        )
        addGestureRecognizer(holdGestureRecognizer)
    }

    @objc func deleteView(gesture: UILongPressGestureRecognizer) {
        delegate.holdToDeletePeg(gesture)
    }

    // Unbinds uiImage subview to avoid reference cycles
    // when it is removed from view to be deallocated.
    override func removeFromSuperview() {
        super.removeFromSuperview()
        subviews.forEach { $0.removeFromSuperview() }
    }

    // Overriden for testing purposes
    override func isEqual(_ object: Any?) -> Bool {
        guard let otherPeg = object as? PegView else {
            return false
        }
        return otherPeg.color == color
            && otherPeg.frame == otherPeg.frame
    }
}