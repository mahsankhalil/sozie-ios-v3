//
//  FitTipsSelectionCell.swift
//  Sozie
//
//  Created by Malik Hantash Nadeem on 25/11/2020.
//  Copyright © 2020 Danial Zahid. All rights reserved.
//

import UIKit

class FitTipsSelectionCell: UITableViewCell {
    @IBOutlet weak var selectorImage: UIImageView!
    @IBOutlet weak var optionNameLabel: UILabel!
    
    static let identifier = "FitTipsSelectionCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "FitTipsSelectionCell", bundle: nil)
    }
    
    public func configure(imageName: String, optionName: String) {
        selectorImage.image = UIImage(named: imageName)
        optionNameLabel.text = optionName
        if imageName == "fitTips_selected" {
            optionNameLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        else {
            optionNameLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
