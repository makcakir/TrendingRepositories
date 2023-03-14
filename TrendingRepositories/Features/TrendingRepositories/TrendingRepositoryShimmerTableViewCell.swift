//
//  TrendingRepositoryShimmerTableViewCell.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 13.01.2023.
//

import UIKit

final class TrendingRepositoryShimmerTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var avatarView: UIView!
    @IBOutlet private weak var titleView: UIView!
    @IBOutlet private weak var detailView: UIView!
    @IBOutlet private weak var indexView: UIView!
    private var avatarViewGradientLayer: CAGradientLayer?
    private var titleViewGradientLayer: CAGradientLayer?
    private var detailViewGradientLayer: CAGradientLayer?
    private var indexViewGradientLayer: CAGradientLayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        avatarView.makeCornersRounded()
        titleView.makeCornersRounded()
        detailView.makeCornersRounded()
        indexView.makeCornersRounded()
        addShimmerAnimationToSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        detailViewGradientLayer?.frame = detailView.bounds
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        removeShimmerAnimationFromSubviews()
        addShimmerAnimationToSubviews()
    }
}

private extension TrendingRepositoryShimmerTableViewCell {
    
    func addShimmerAnimationToSubviews() {
        avatarViewGradientLayer = avatarView.addShimmerAnimation()
        titleViewGradientLayer = titleView.addShimmerAnimation()
        detailViewGradientLayer = detailView.addShimmerAnimation()
        indexViewGradientLayer = indexView.addShimmerAnimation()
    }
    
    func removeShimmerAnimationFromSubviews() {
        avatarViewGradientLayer?.removeFromSuperlayer()
        titleViewGradientLayer?.removeFromSuperlayer()
        detailViewGradientLayer?.removeFromSuperlayer()
        indexViewGradientLayer?.removeFromSuperlayer()
    }
}
