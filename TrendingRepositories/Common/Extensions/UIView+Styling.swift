//
//  UIView+Styling.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 12.01.2023.
//

import UIKit

// swiftlint:disable no_magic_numbers
extension UIView {

    private enum Const {
        static let animationDuration: CGFloat = 0.8
        static let animationKey = "shimmerAnimation"
    }

    func makeCornersRounded() {
        makeCornersRounded(cornerRadius: frame.height / 2)
    }

    func makeCornersRounded(cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }

    @discardableResult
    func addShimmerAnimation() -> CAGradientLayer {
        let darkColor = UIColor.systemGray5.cgColor
        let lightColor = UIColor.systemGray6.cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [darkColor, lightColor, darkColor]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        layer.addSublayer(gradientLayer)

        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.repeatCount = .infinity
        animation.duration = Const.animationDuration

        gradientLayer.add(animation, forKey: Const.animationKey)
        return gradientLayer
    }
}
// swiftlint:enable no_magic_numbers
