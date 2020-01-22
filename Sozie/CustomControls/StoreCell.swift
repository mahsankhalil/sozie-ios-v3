//
//  StoreCell.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 5/29/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class StoreCell: UITableViewCell {

    @IBOutlet weak var quantityLeftTitle: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
extension StoreCell: CellConfigurable {
    func setup(_ viewModel: RowViewModel) {
        if let titleViewModel = viewModel as? TitleViewModeling {
            if let title = titleViewModel.title {
                titleLabel.text = title
            } else if let attrTitle = titleViewModel.attributedTitle {
                titleLabel.attributedText = attrTitle
            }
        }
        if let descriptionViewModel = viewModel as? DescriptionViewModeling {
            descriptionLabel.text = descriptionViewModel.description
        }
        if let countViewModel = viewModel as? CountViewModeling {
            quantityLeftTitle.text = "only " + String(countViewModel.count) + " left"
        }
        if let availabilityModel = viewModel as? AvailabilityProviding {
            if availabilityModel.isAvailable {
                quantityLeftTitle.text = "Available"
            } else {
                quantityLeftTitle.text = "Not Available"
            }
        }
    }
}
