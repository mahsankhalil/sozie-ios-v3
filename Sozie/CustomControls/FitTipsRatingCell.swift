//
//  FitTipsRatingCell.swift
//  Sozie
//
//  Created by Malik Hantash Nadeem on 25/11/2020.
//  Copyright © 2020 Danial Zahid. All rights reserved.
//

import UIKit
import Cosmos

class FitTipsRatingCell: UITableViewCell {
    @IBOutlet weak var ratingView: CosmosView!
    
    static let identifier = "FitTipsRatingCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "FitTipsRatingCell", bundle: nil)
    }
    
    public func configure(rating: Double) {
        ratingView.rating = rating
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
