//
//  PostCollectionViewCell.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/13/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
protocol PostCollectionViewCellDelegate {
    func moreButtonTapped(button: UIButton)
    func followButtonTapped(button: UIButton)
}
class PostCollectionViewCell: UICollectionViewCell {
    var delegate: PostCollectionViewCellDelegate?
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var waistLabel: UILabel!
    @IBOutlet weak var hipLabel: UILabel!
    @IBOutlet weak var braLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var sizeWornView: UIView!
    @IBOutlet weak var sizeWornLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.makeViewCircle()
        profileImageView.applyStandardBorder(hexColor: "A6A6A6")
    }
    @IBAction func followButtonTapped(_ sender: Any) {
        
        delegate?.followButtonTapped(button: sender as! UIButton)
    }
    @IBAction func moreButtonTapped(_ sender: Any) {
        delegate?.moreButtonTapped(button: sender as! UIButton)
    }

}
extension PostCollectionViewCell: CellConfigurable {
    func setup(_ viewModel: RowViewModel) {
        if let imgModel = viewModel as? ImageViewModeling {
            postImageView.sd_setImage(with: imgModel.imageURL) { (_, _, _, _) in
                
            }
        }
        if let titleModel = viewModel as? TitleViewModeling {
            if let title = titleModel.title {
                nameLabel.text = title
            } else if let title = titleModel.attributedTitle {
                nameLabel.attributedText = title
            }
        }
        if let descriptionViewModel = viewModel as? DescriptionViewModeling {
            sizeWornLabel.text = descriptionViewModel.description
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
            if let indexModel = viewModel as? IndexViewModeling {
                if let index = indexModel.index {
                    followButton.tag = index
                    moreButton.tag = index
                }
                
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
        }
    }

}
