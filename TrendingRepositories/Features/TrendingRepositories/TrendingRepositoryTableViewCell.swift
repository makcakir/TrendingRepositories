//
//  TrendingRepositoryTableViewCell.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 12.01.2023.
//

import SwifterSwift
import UIKit

protocol TrendingRepositoryTableViewCellDelegate: AnyObject {

    func trendingRepositoryTableViewCellDidTapTitleButton(cell: TrendingRepositoryTableViewCell)
    func trendingRepositoryTableViewCellDidTapInfoButton(cell: TrendingRepositoryTableViewCell)
}

final class TrendingRepositoryTableViewCell: UITableViewCell {

    private enum Const {
        static let bordorWidth: CGFloat = 0.5
    }

    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var ownerNameLabel: UILabel!
    @IBOutlet private weak var titleButton: UIButton!
    @IBOutlet private weak var detailStackView: UIStackView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var languageContentView: UIView!
    @IBOutlet private weak var languageColorView: UIView!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var starCountLabel: UILabel!
    @IBOutlet private weak var indexLabel: UILabel!
    @IBOutlet private weak var infoButton: UIButton!

    weak var delegate: TrendingRepositoryTableViewCellDelegate?

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
        languageColorView.layer.borderColor = UIColor.label.cgColor
    }

    func fill(_ presentation: TrendingRepositoryPresentation) {
        // swiftlint:disable:next discouraged_object_literal
        profileImageView.setImage(presentation.owner.imageUrl, placeholderImage: #imageLiteral(resourceName: "avatar"))
        indexLabel.text = presentation.index
        ownerNameLabel.text = presentation.owner.name
        titleButton.setTitle(presentation.title, for: .normal)
        descriptionLabel.isHidden = presentation.description?.isEmpty ?? true
        descriptionLabel.text = presentation.description
        languageContentView.isHidden = presentation.language == nil
        languageColorView.backgroundColor = UIColor(hexString: presentation.language?.colorHex ?? "")
        languageLabel.text = presentation.language?.name
        starCountLabel.text = presentation.starCount
        detailStackView.isHidden = !presentation.isExpanded
        if presentation.shouldDisplayInfoButton {
            infoButton.isHidden = !presentation.isExpanded
            infoButton.isEnabled = true
        } else {
            infoButton.isHidden = true
            infoButton.isEnabled = false
        }
    }

    func toggleExpanded() {
        detailStackView.isHidden.toggle()
        if infoButton.isEnabled {
            infoButton.isHidden.toggle()
        }
    }

    @IBAction private func titleButtonTapped(_ sender: Any) {
        delegate?.trendingRepositoryTableViewCellDidTapTitleButton(cell: self)
    }

    @IBAction private func infoButtonTapped(_ sender: Any) {
        delegate?.trendingRepositoryTableViewCellDidTapInfoButton(cell: self)
    }
}
