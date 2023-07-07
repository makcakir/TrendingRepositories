//
//  UIImageView+ImageLoading.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 13.01.2023.
//

import Kingfisher
import UIKit

extension UIImageView {

    func setImage(_ imageUrl: URL, placeholderImage: UIImage? = nil) {
        kf.setImage(with: imageUrl, placeholder: placeholderImage)
    }
}
