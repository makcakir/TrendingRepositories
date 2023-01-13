//
//  UIImageView+ImageLoading.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 13.01.2023.
//

import SDWebImage

extension UIImageView {
    
    func setImage(_ imageUrl: String, placeholderImage: UIImage? = nil) {
        let url = URL(string: imageUrl)
        sd_setImage(with: url, placeholderImage: placeholderImage)
    }
}
