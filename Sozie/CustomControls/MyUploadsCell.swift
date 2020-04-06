//
//  MyUploadsCell.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 9/24/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
protocol MyUploadsCellDelegate: class {
    func deleteButtonTapped(button: UIButton)
    func viewBalanceButtonTapped(button: UIButton)
    func resetTutorialButtonTapped(button: UIButton)
}

class MyUploadsCell: UITableViewCell {
    @IBOutlet weak var resetTutrialButton: UIButton!
    @IBOutlet weak var cornerIcon: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var viewBalanceButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var requestedForLabel: UILabel!
    @IBOutlet weak var requestedForImageView: UIImageView!
    weak var delegate: MyUploadsCellDelegate?
    fileprivate let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    var viewModels: [UploadViewModel] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.register(UINib(nibName: "PostSizeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PostSizeCollectionViewCell")

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func deleteButtonTapped(_ sender: Any) {
        delegate?.deleteButtonTapped(button: sender as! UIButton)
    }
    @IBAction func viewBalanceButtonTapped(_ sender: Any) {
        delegate?.viewBalanceButtonTapped(button: sender as! UIButton)
    }
    @IBAction func resetTutorialButtonTapped(_ sender: Any) {
        UserDefaultManager.makeUserGuideEnable()
        UserDefaultManager.removeAllUserGuidesShown()
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "ResetFirstTime")))
        delegate?.resetTutorialButtonTapped(button: sender as! UIButton)
    }
}
extension MyUploadsCell: ButtonProviding {
    func assignTagWith(_ index: Int) {
        deleteButton.tag = index
        viewBalanceButton.tag = index
    }
}
extension MyUploadsCell: CellConfigurable {
    func setup(_ viewModel: RowViewModel) {
        if let postViewModel = viewModel as? UserPostWithUploadsViewModel {
            viewModels.removeAll()
            for upload in postViewModel.uploads {
                let currentViewModel = UploadViewModel(imageURL: URL(string: upload.imageURL)!, status: upload.reviewAction, isApproved: upload.isApproved)
                viewModels.append(currentViewModel)
            }
            self.collectionView.reloadData()
            self.resetTutrialButton.isHidden = true
            if postViewModel.isModerated == true {
                self.descriptionLabel.isHidden = false
            } else {
                self.descriptionLabel.isHidden = true
            }
            if postViewModel.isApproved {
                self.bottomView.backgroundColor = UtilityManager.getGenderColor()
                if postViewModel.isTutorial {
                    showTutorialApproved(postViewModel: postViewModel)
                } else {
                    showPostApproved(postViewModel: postViewModel)
                }
                self.viewBalanceButton.isEnabled = true
            } else {
                self.bottomView.backgroundColor = UIColor(hex: "DCDCDC")
                if postViewModel.isTutorial {
                    showTutorialNotApproved(postViewModel: postViewModel)
                } else {
                    showPostNotApproved(postViewModel: postViewModel)
                }
                self.viewBalanceButton.isEnabled = false
            }
            if let user = UserDefaultManager.getCurrentUserObject() {
                if let country = user.country {
                    if country == 1 {
                        self.requestedForImageView.image = UIImage(named: "Adidas-Title")
                    } else {
                        self.requestedForImageView.image = UIImage(named: "Target-title")
                    }
                }
            }
        }
    }
    func showPostApproved(postViewModel: UserPostWithUploadsViewModel) {
        self.cornerIcon.isHidden = true
        self.descriptionLabel.text = "Post approved"
        self.viewBalanceButton.isHidden = false
        self.resetTutrialButton.isHidden = true
        requestedForLabel.isHidden = false
        requestedForImageView.isHidden = false
        self.deleteButton.isHidden = false
    }
    func showPostNotApproved(postViewModel: UserPostWithUploadsViewModel) {
        self.cornerIcon.isHidden = true
        self.descriptionLabel.text = "Post not approved"
        self.viewBalanceButton.isHidden = false
        self.resetTutrialButton.isHidden = true
        requestedForLabel.isHidden = false
        requestedForImageView.isHidden = false
        self.deleteButton.isHidden = false
    }
    func showTutorialApproved(postViewModel: UserPostWithUploadsViewModel) {
        self.cornerIcon.isHidden = false
        self.descriptionLabel.text = "Tutorial approved"
        self.viewBalanceButton.isHidden = true
        self.resetTutrialButton.isHidden = true
        requestedForLabel.isHidden = true
        requestedForImageView.isHidden = true
        self.deleteButton.isHidden = true
    }
    func showTutorialNotApproved(postViewModel: UserPostWithUploadsViewModel) {
        self.cornerIcon.isHidden = false
        self.descriptionLabel.text = "Tutorial not approved"
        self.viewBalanceButton.isHidden = true
        if postViewModel.isModerated == true {
            self.resetTutrialButton.isHidden = false
        } else {
            self.resetTutrialButton.isHidden = true
        }
        requestedForLabel.isHidden = true
        requestedForImageView.isHidden = true
        self.deleteButton.isHidden = true
    }
}
extension MyUploadsCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let rowViewModel = viewModels[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostSizeCollectionViewCell", for: indexPath)
        if let cellConfigurable = cell as? CellConfigurable {
            cellConfigurable.setup(rowViewModel)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let availableWidth: Int = Int(UIScreen.main.bounds.size.width - 6 )
//        let widthPerItem = Double(availableWidth/3)
        return CGSize(width: 110, height: 110 )
    }
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3.0
    }
    // 4
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3.0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        currentPost = posts[indexPath.row]
//        self.performSegue(withIdentifier: "toProductDetail", sender: self)
    }
}
