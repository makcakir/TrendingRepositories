//
//  UIView+Styling.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 12.01.2023.
//

import UIKit

extension UIView {
    
    func makeCornersRounded() {
        layer.cornerRadius = frame.height / 2
        clipsToBounds = true
    }
}
