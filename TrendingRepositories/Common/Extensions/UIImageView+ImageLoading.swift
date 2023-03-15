//
//  UIImageView+ImageLoading.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 13.01.2023.
//

import SDWebImage

extension UIImageView {
    
    func setImage(_ imageUrl: URL, placeholderImage: UIImage? = nil) {
        sd_setImage(with: imageUrl, placeholderImage: placeholderImage)
    }
}
