//
//  SozieTableViewCell.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/21/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
protocol SozieTableViewCellDelegate {
    func followButtonTapped(button: UIButton)
}
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
    var delegate: SozieTableViewCellDelegate?
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

    func makeButtonFollow() {
        followButton.setTitle("Follow", for: .normal)
        followButton.backgroundColor = UIColor(hex: "7EA7E5")
        followButton.setTitleColor(UIColor.white, for: .normal)
        followButton.layer.cornerRadius = 3.0
    }
    func makeButtonFollowing() {
        followButton.setTitle("Following", for: .normal)
        followButton.backgroundColor = UIColor.white
        followButton.setTitleColor(UIColor(hex: "7EA7E5"), for: .normal)
        followButton.layer.borderWidth = 1.0
        followButton.layer.borderColor = UIColor(hex: "7EA7E5").cgColor
        followButton.layer.cornerRadius = 3.0
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func followButtonTapped(_ sender: Any) {
        delegate?.followButtonTapped(button: sender as! UIButton)
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
            if followModel.isFollow  == true {
                makeButtonFollowing()
            } else {
                makeButtonFollow()
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
extension SozieTableViewCell: ButtonProviding {
    func assignTagWith(_ index: Int) {
        followButton.tag = index
    }
}
