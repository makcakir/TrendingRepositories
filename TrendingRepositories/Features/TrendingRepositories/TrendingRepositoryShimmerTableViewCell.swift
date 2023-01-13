//
//  TrendingRepositoryShimmerTableViewCell.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 13.01.2023.
//

import UIKit

class TrendingRepositoryShimmerTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var avatarView: UIView!
    @IBOutlet private weak var titleView: UIView!
    @IBOutlet private weak var detailView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        avatarView.makeCornersRounded()
        titleView.makeCornersRounded()
        detailView.makeCornersRounded()
        avatarView.addShimmerAnimation()
        titleView.addShimmerAnimation()
        detailView.addShimmerAnimation()
    }
}
