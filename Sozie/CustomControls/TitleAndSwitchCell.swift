//
//  TitleAndSwitchCell.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/28/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class TitleAndSwitchCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchControl: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        switchControl.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension TitleAndSwitchCell: CellConfigurable {
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
        
        if let switchModel = viewModel as? SwitchProviding {
            switchControl.setOn(switchModel.isSwitchOn ?? false, animated: true)
        }
        
        
    }
}
