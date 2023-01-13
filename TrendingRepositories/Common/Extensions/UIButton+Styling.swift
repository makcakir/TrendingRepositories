//
//  UIButton+Styling.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 13.01.2023.
//

import UIKit

extension UIButton {
    
    private enum Const {
        static let cornerRadius: CGFloat = 4.0
        static let borderWidth: CGFloat = 1.0
    }
    
    func applyRoundedRectStyling(
        cornerRadius: CGFloat = Const.cornerRadius, borderWidth: CGFloat = Const.borderWidth,
        color: UIColor = .systemGreen
    ) {
        setTitleColor(color, for: .normal)
        setTitleColor(color, for: .highlighted)
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = color.cgColor
        clipsToBounds = true
    }
}
