//
//  TermsConditionCell.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 7/27/20.
//  Copyright © 2020 Danial Zahid. All rights reserved.
//

import UIKit

class TermsConditionCell: UITableViewCell {

    @IBOutlet weak var bottomLine: UIView!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
extension TermsConditionCell: CellConfigurable {
    func setup(_ viewModel: RowViewModel) {
        if let currentViewModel = viewModel as? TermsConditionViewModel {
            if let title = currentViewModel.title {
                self.titleLabel.text = title
                if title == "Terms and Conditions" {
                    self.bottomLine.isHidden = false
                } else {
                    self.bottomLine.isHidden = true
                }
            }
            if let description = currentViewModel.subtitle {
                if currentViewModel.isAvailable == true {
                    self.descriptionLabel.text = description
                } else {
                    self.descriptionLabel.text = nil
                }
            }
            if currentViewModel.isAvailable == false {
                self.arrowImageView.image = UIImage(named: "Arrow Down")
            } else {
                self.arrowImageView.image = UIImage(named: "Arrow Up")
            }
        }
    }
}
