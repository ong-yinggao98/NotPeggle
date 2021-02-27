//
//  BlockView.swift
//  NotPeggle
//
//  Created by Ying Gao on 27/2/21.
//

import UIKit

/**
 View representation of a `Block`.
 It comprises gesture recognizers for dragging and deletion.
 */
class BlockView: UIView {

    static var sprite: UIImageView {
        UIImageView(image: #imageLiteral(resourceName: "Block"))
    }

    private(set) var width: CGFloat
    private(set) var height: CGFloat
    private(set) var angle: CGFloat

    weak var delegate: BlockViewDelegate!

    init(center: CGPoint, width: CGFloat, height: CGFloat, angle: CGFloat) {
        self.width = width
        self.height = height
        self.angle = angle
        let origin = CGPoint(x: center.x - (width / 2), y: center.y - (height / 2))
        super.init(frame: CGRect(x: origin.x, y: origin.y, width: width, height: height))

        isUserInteractionEnabled = true
        initialiseImage()
        setUpGestureRecognition()
        transform = CGAffineTransform(rotationAngle: angle)
    }

    private func initialiseImage() {
        let imageView = BlockView.sprite
        imageView.frame = bounds
        addSubview(imageView)
    }

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
        delegate.dragBlock(gesture)
    }

    func setUpLongPressRecognition() {
        let holdGestureRecognizer = UILongPressGestureRecognizer(
            target: self,
            action: #selector(deleteView(gesture:))
        )
        addGestureRecognizer(holdGestureRecognizer)
    }

    @objc func deleteView(gesture: UILongPressGestureRecognizer) {
        delegate.holdToDeleteBlock(gesture)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

/**
 Delegate protocol to enable a controller to make changes to data based on
 gestures applied to a `BlockView`.
 */
protocol BlockViewDelegate: AnyObject {

    func holdToDeleteBlock(_ gesture: UILongPressGestureRecognizer)

    func dragBlock(_ gesture: UIPanGestureRecognizer)

}
