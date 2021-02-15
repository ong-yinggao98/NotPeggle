//
//  GamePegView.swift
//  NotPeggle
//
//  Created by Ying Gao on 13/2/21.
//

import UIKit

/**
 View representation of a `GamePeg`. While visually similar to `PegView`, it supports different operations.
 Namely, it can be lit up and faded out, and unlike the latter, cannot be dragged or deleted by pressing.
 */
class GamePegView: UIView {

    var color: Color
    var image: UIImageView!

    static var orangeImage: UIImageView {
        let orange = UIImage(named: "orange-bubble")
        let orangeHighlight = UIImage(named: "orange-glow")
        return UIImageView(image: orange, highlightedImage: orangeHighlight)
    }

    static var blueImage: UIImageView {
        let blue = UIImage(named: "blue-bubble")
        let blueHighlight = UIImage(named: "blue-glow")
        return UIImageView(image: blue, highlightedImage: blueHighlight)
    }

    init(radius: CGFloat, center: CGPoint, color: Color) {
        let frame = CGFrameFactory.createFrame(center: center, radius: radius)
        self.color = color
        super.init(frame: frame)
        setUpImage()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpImage() {
        switch color {
        case .orange:
            resizeToFrameAndApply(imageView: GamePegView.orangeImage)
        case .blue:
            resizeToFrameAndApply(imageView: GamePegView.blueImage)
        }
    }

    func resizeToFrameAndApply(imageView: UIImageView) {
        image = imageView
        image.frame = bounds
        addSubview(image)
    }

    func highlight() {
        image.isHighlighted = true
    }

    func makeTransparent() {
        image.alpha = 0
    }

    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? GamePegView else {
            return false
        }
        return color == other.color && frame == other.frame
    }

}
