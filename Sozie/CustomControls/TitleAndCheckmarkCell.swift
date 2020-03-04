//
//  TitleAndCheckmarkCell.swift
//  Sozie
//
//  Created by Omair Baskanderi on 2019-01-19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class TitleAndCheckmarkCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkmarkImageView: UIImageView!
}

extension TitleAndCheckmarkCell: CellConfigurable {
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
        // Check for CheckmarkViewModeling
        checkmarkImageView.isHidden = true
        if let checkmarkModel = viewModel as? CheckmarkViewModeling {
            checkmarkImageView.isHidden = checkmarkModel.isCheckmarkHidden
            if let optionViewModel = viewModel as? OptionsViewModel {
                if optionViewModel.isFromFitTips == true {
                    if checkmarkModel.isCheckmarkHidden == true {
                        self.titleLabel.textColor = UIColor(hex: "888888")
                    } else {
                        self.titleLabel.textColor = UtilityManager.getGenderColor()
                    }
                }
            }
        }
    }
}
