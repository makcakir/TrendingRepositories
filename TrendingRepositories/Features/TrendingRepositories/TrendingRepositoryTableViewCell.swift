//
//  TrendingRepositoryTableViewCell.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 12.01.2023.
//

import UIKit

class TrendingRepositoryTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var ownerNameLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private(set) weak var detailStackView: UIStackView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var languageContentView: UIView!
    @IBOutlet private weak var languageColorView: UIView!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var starCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        profileImageView.makeCornersRounded()
        languageColorView.makeCornersRounded()
    }
    
    func fill(_ presentation: TrendingRepositoryPresentation) {
        ownerNameLabel.text = presentation.owner.name
        titleLabel.text = presentation.title
        descriptionLabel.text = presentation.description
        if let language = presentation.language {
            languageContentView.isHidden = false
            let color = UIColor(hex: language.colorHex)
            profileImageView.backgroundColor = color
            languageColorView.backgroundColor = color
            languageLabel.text = language.name
        } else {
            languageContentView.isHidden = true
            profileImageView.backgroundColor = .label
            languageColorView.backgroundColor = nil
            languageLabel.text = nil
        }
        starCountLabel.text = presentation.starCount
        detailStackView.isHidden = !presentation.isExpanded
    }
}
