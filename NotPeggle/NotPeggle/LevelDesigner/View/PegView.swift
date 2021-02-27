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

    static var bluePeg: UIImageView! {
        UIImageView(image: #imageLiteral(resourceName: "blue-bubble"))
    }
    static var orangePeg: UIImageView! {
        UIImageView(image: #imageLiteral(resourceName: "orange-bubble"))
    }
    static var greenPeg: UIImageView! {
        UIImageView(image: #imageLiteral(resourceName: "green-bubble"))
    }

    // MARK: Instance variables
    let color: Color
    weak var delegate: PegViewDelegate!

    var radius: CGFloat {
        frame.height / 2
    }

    // MARK: Initialisers
    init(center: CGPoint, color: Color, radius: CGFloat) {
        let frame = PegView.createFrameFrom(center, radius: radius)
        self.color = color
        super.init(frame: frame)

        setImageBasedOnColor()

        isUserInteractionEnabled = true
        setUpGestureRecognition()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("This class should not be created in a Storyboard")
    }

    // MARK: Methods
    private static func createFrameFrom(_ center: CGPoint, radius: CGFloat) -> CGRect {
        let origin = createOriginFrom(center, radius: radius)
        let length = 2 * radius
        let size = CGSize(width: length, height: length)
        return CGRect(origin: origin, size: size)
    }

    private static func createOriginFrom(_ center: CGPoint, radius: CGFloat) -> CGPoint {
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
        case .green:
            return PegView.greenPeg
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
            && otherPeg.frame == frame
    }
}

/**
 Delegate protocol to enable a controller to make changes to data based on
 gestures applied to a `PegView`.
 */
protocol PegViewDelegate: AnyObject {

    func holdToDeletePeg(_ gesture: UILongPressGestureRecognizer)

    func dragPeg(_ gesture: UIPanGestureRecognizer)
}
