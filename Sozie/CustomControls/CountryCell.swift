//
//  CountryCell.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/3/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class CountryCell: UITableViewCell {

    @IBOutlet weak var checkMarkImgVu: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func hideCheckMark()
    {
        self.checkMarkImgVu.isHidden = true
    }
    
    func showCheckMark()
    {
        self.checkMarkImgVu.isHidden = false
    }
    
}
