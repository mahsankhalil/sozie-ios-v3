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
    func cameraButtonTapped(button: UIButton)
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
    @IBOutlet weak var followButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var cameraButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.makeViewCircle()
        profileImageView.applyStandardBorder(hexColor: "A6A6A6")
        sizeWornView.roundCorners(corners: [.topLeft], radius: 20.0)
        if UserDefaultManager.getIfShopper() {
            followButtonWidthConstraint.constant = 60.0
            cameraButton.isHidden = true
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if let _ = appDelegate.imageTaken {
                cameraButton.isHidden = true
            } else {
                cameraButton.isHidden = false
            }
            followButtonWidthConstraint.constant = 0.0
            followButton.isHidden = true
        }
    }
    @IBAction func followButtonTapped(_ sender: Any) {
        delegate?.followButtonTapped(button: sender as! UIButton)
    }
    @IBAction func moreButtonTapped(_ sender: Any) {
        delegate?.moreButtonTapped(button: sender as! UIButton)
    }
    @IBAction func cameraButtonTapped(_ sender: Any) {
        delegate?.cameraButtonTapped(button: sender as! UIButton)
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
                    cameraButton.tag = index
                }
                
            }
            if let followModel = viewModel as? FollowViewModeling {
                if let isFollowed = followModel.isFollow {
                    if isFollowed == true {
                        makeButtonFollowing()
                    } else {
                        makeButtonFollow()
                    }
                }
            }
        }
    }

}
