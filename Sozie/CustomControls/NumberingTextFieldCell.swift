//
//  NumberingTextFieldCell.swift
//  Sozie
//
//  Created by Ahsan Khalil on 03/12/2020.
//  Copyright © 2020 Danial Zahid. All rights reserved.
//

import UIKit

class NumberingTextFieldCell: UITableViewCell {
    static let identifier = "NumberingTextFieldCell"
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
         //Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    public func configure(itemNumber: Int, description: String, itemNumberColor: UIColor) {
        numberLabel.text = String(itemNumber) + "."
        descriptionLabel.text = description
        numberLabel.textColor = itemNumberColor
    }
}
