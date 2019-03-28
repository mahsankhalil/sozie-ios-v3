//
//  DisclosureCell.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/6/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class DisclosureCell: UITableViewCell {

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
extension DisclosureCell: CellConfigurable {
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
        
    }
}
