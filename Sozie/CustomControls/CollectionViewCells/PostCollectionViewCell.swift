//
//  PostCollectionViewCell.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/13/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import EasyTipView

protocol PostCollectionViewCellDelegate: class {
    func moreButtonTapped(button: UIButton)
    func followButtonTapped(button: UIButton)
    func cameraButtonTapped(button: UIButton)
    func profileButtonTapped(button: UIButton)
}
class PostCollectionViewCell: UICollectionViewCell {
    weak var delegate: PostCollectionViewCellDelegate?
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
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var usernameButton: UIButton!
    var tipView: EasyTipView?
    var isFirstTime = true
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
            if appDelegate.imageTaken != nil {
                cameraButton.isHidden = true
            } else {
                cameraButton.isHidden = false
            }
            followButtonWidthConstraint.constant = 0.0
            followButton.isHidden = true
        }
        cameraButton.isHidden = true
    }
    @objc func dismissTipView() {
        tipView?.dismiss(withCompletion: nil)
    }
    override func layoutIfNeeded() {
    }
    @objc func showTipView() {
        if UserDefaultManager.isUserGuideDisabled() == false {
            if (self.followButton.tag == 1) && (self.followButton.isHidden == false) {
                if isFirstTime {
                    let text = "Click here to Follow this Sozie"
                    var prefer = UtilityManager.tipViewGlobalPreferences()
                    prefer.drawing.arrowPosition = .bottom
                    prefer.positioning.maxWidth = 110
                    tipView = EasyTipView(text: text, preferences: prefer, delegate: nil)
                    tipView?.show(animated: true, forView: self.followButton, withinSuperview: self.topView)
                    isFirstTime = false
                    UserDefaultManager.setUserGuideShown(userGuide: UserDefaultKey.followButtonUserGuide)
                    perform(#selector(self.dismissTipView), with: nil, afterDelay: 5.0)
                }
            }
        }
    }
    @IBAction func profileButtonTapped(_ sender: Any) {
        delegate?.profileButtonTapped(button: sender as! UIButton)
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
            postImageView.sd_setShowActivityIndicatorView(true)
            postImageView.sd_setIndicatorStyle(.gray)
            postImageView.sd_setImage(with: imgModel.imageURL, completed: nil)
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
        assignMeasurements(viewModel: viewModel)
        if UserDefaultManager.getIfShopper() {
            if followButton.tag == 1 {
                tipView?.isHidden = false
            } else {
                tipView?.isHidden = true
            }
            if UserDefaultManager.getIfUserGuideShownFor(userGuide: UserDefaultKey.followButtonUserGuide) == false {
                perform(#selector(showTipView), with: nil, afterDelay: 0.5)
            }
        }
    }
    func assignMeasurements(viewModel: RowViewModel) {
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
            if let followModel = viewModel as? FollowViewModeling {
                if followModel.isFollow  == true {
                    makeButtonFollowing()
                } else {
                    makeButtonFollow()
                }
            }
        }

    }

}
extension PostCollectionViewCell: ButtonProviding {
    func assignTagWith(_ index: Int) {
        followButton.tag = index
        moreButton.tag = index
        cameraButton.tag = index
        profileButton.tag = index
        usernameButton.tag = index
    }
}
