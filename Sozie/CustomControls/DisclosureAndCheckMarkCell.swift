//
//  DisclosureAndCheckMarkCell.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 5/21/20.
//  Copyright © 2020 Danial Zahid. All rights reserved.
//

import UIKit

class DisclosureAndCheckMarkCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkMarkImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
extension DisclosureAndCheckMarkCell: CellConfigurable {
    func setup(_ viewModel: RowViewModel) {
        // Check for TitleViewModeling
        if let titleModel = viewModel as? TitleViewModeling {
            if let title = titleModel.title {
                titleLabel.text = title
            }
            if let attributedTitle = titleModel.attributedTitle {
                titleLabel.attributedText = attributedTitle
            }
        }
        if let model = viewModel as? FitTipsViewModel {
            if model.isFromFitTips {
                if let selectionModel = viewModel as? SelectionProviding {
                    if selectionModel.isSelected {
                        self.checkMarkImageView.isHidden = false
//                        self.titleLabel.textColor = UIColor(hex: "FC8787")
                    } else {
                        self.checkMarkImageView.isHidden = true
//                        self.titleLabel.textColor = UIColor(hex: "888888")
                    }
                }
            }
        }
        // Check for CheckmarkViewModeling
    }
}
