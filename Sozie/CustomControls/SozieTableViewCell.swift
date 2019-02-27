//
//  SozieTableViewCell.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/21/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class SozieTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var waistLabel: UILabel!
    @IBOutlet weak var hipLabel: UILabel!
    @IBOutlet weak var braLabel: UILabel!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var backgroudView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroudView.layer.borderWidth = 0.5
        backgroudView.layer.borderColor = UIColor(hex: "A6A6A6").cgColor
        backgroudView.applyShadowWith(radius: 4, shadowOffSet: CGSize(width: -4, height: 4), opacity: 0.1)
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2.0
        profileImageView.layer.borderColor = UIColor(hex: "DDDDDD").cgColor
        followButton.layer.cornerRadius = 3.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension SozieTableViewCell: CellConfigurable {
    func setup(_ viewModel: RowViewModel) {

        if let titleImgModel = viewModel as? TitleImageViewModeling {
            titleImageView.sd_setImage(with: titleImgModel.titleImageURL, completed: nil)
        }
        if let titleModel = viewModel as? TitleViewModeling {
            nameLabel.text = titleModel.title!
        }
        if let followModel = viewModel as? FollowViewModeling {
            if let isFollowed = followModel.isFollow {
                if isFollowed == true {
                    self.followButton.isHidden = true
                } else {
                    self.followButton.isHidden = false
                }
            }
        }
        if let measurementModel = viewModel as? MeasurementViewModeling {
            if let bra = measurementModel.bra, let cup = measurementModel.cup {
                braLabel.text = "Bra Size: " + String(bra) + cup
            }
            if let height = measurementModel.height {
                let heightMeasurment = NSMeasurement(doubleValue: Double(height), unit: UnitLength.inches)
                let feetMeasurement = heightMeasurment.converting(to: UnitLength.feet)
                heightLabel.text = "Height: " + feetMeasurement.value.feetToFeetInches() + "  |"
                
            }
            if let hip = measurementModel.hip {
                hipLabel.text = "Hip: " + String(hip) + "  |"
            }
            if let waist = measurementModel.waist {
                waistLabel.text = "Waist: " + String(waist) + "  |"
            }
        }
    }
}
