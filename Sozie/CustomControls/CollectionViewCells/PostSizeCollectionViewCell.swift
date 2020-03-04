//
//  PostSizeCollectionViewCell.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 3/1/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class PostSizeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelBackgroundView: UIView!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageView.sd_setShowActivityIndicatorView(true)
        imageView.sd_setIndicatorStyle(.gray)
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        labelBackgroundView.roundCorners(corners: [.topLeft], radius: 20.0)
    }

}
extension PostSizeCollectionViewCell: CellConfigurable {
    func setup(_ viewModel: RowViewModel) {
        if let imgModel = viewModel as? ImageViewModeling {
            imageView.sd_setImage(with: imgModel.imageURL) { (_, _, _, _) in
            }
        }
        if let subtitleModel = viewModel as? SubtitleViewModeling {
            sizeLabel.text = subtitleModel.subtitle
        }
        if let selectionModel = viewModel as? SelectionProviding {
            if selectionModel.isSelected == true {
                self.statusImageView.image = UIImage(named: "checked")
            } else {
                self.statusImageView.image = UIImage(named: "cancel")
            }
        }
        if let postViewModel = viewModel as? UserPostCellViewModel {
            if postViewModel.status == "P" {
                self.statusImageView.isHidden = true
            } else {
                self.statusImageView.isHidden = false
            }
        }
        if let uploadViewModel = viewModel as? UploadViewModel {
            imageView.sd_setImage(with: uploadViewModel.imageURL) { (_, _, _, _) in
            }
            if uploadViewModel.status == "P" {
                self.statusImageView.isHidden = true
            } else {
                self.statusImageView.isHidden = false
            }
            if uploadViewModel.isApproved == true {
                self.statusImageView.image = UIImage(named: "checked")
            } else {
                self.statusImageView.image = UIImage(named: "cancel")
            }
        }
    }
}
