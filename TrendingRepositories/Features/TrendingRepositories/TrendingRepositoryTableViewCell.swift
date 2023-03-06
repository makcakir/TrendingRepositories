//
//  TrendingRepositoryTableViewCell.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 12.01.2023.
//

import UIKit

final class TrendingRepositoryTableViewCell: UITableViewCell {
    
    private enum Const {
        static let bordorWidth: CGFloat = 0.5
    }
    
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var ownerNameLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailStackView: UIStackView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var languageContentView: UIView!
    @IBOutlet private weak var languageColorView: UIView!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var starCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        profileImageView.makeCornersRounded()
        profileImageView.layer.borderColor = UIColor.label.cgColor
        profileImageView.layer.borderWidth = Const.bordorWidth
        languageColorView.makeCornersRounded()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        profileImageView.layer.borderColor = UIColor.label.cgColor
    }
    
    func fill(_ presentation: TrendingRepositoryPresentation) {
        profileImageView.setImage(
            presentation.owner.imageUrl, placeholderImage: #imageLiteral(resourceName: "avatar")
        )
        ownerNameLabel.text = presentation.owner.name
        titleLabel.text = presentation.title
        descriptionLabel.text = presentation.description
        if let language = presentation.language {
            languageContentView.isHidden = false
            let color = UIColor(hex: language.colorHex)
            languageColorView.backgroundColor = color
            languageLabel.text = language.name
        } else {
            languageContentView.isHidden = true
            languageColorView.backgroundColor = nil
            languageLabel.text = nil
        }
        starCountLabel.text = presentation.starCount
        detailStackView.isHidden = !presentation.isExpanded
    }
    
    func toggleExpanded() {
        detailStackView.isHidden.toggle()
    }
}
