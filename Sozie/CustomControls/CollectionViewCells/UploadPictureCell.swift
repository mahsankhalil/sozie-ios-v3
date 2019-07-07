//
//  UploadPictureCell.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 7/2/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class UploadPictureCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var cameraImageView: UIImageView!
    @IBOutlet weak var addMoreLabel: UILabel!
    override func awakeFromNib() {
        self.imageView.layer.borderWidth = 1.0
        self.imageView.layer.borderColor = UIColor(hex: "DBDBDB").cgColor
    }
}
extension UploadPictureCell: CellConfigurable {
    func setup(_ viewModel: RowViewModel) {
        if let titleModel = viewModel as? TitleViewModeling {
            if let title = titleModel.title {
                detailLabel.text = title
                if title == "Optional" {
                    self.cameraImageView.isHidden = true
                    self.addMoreLabel.isHidden = false
                } else {
                    self.cameraImageView.isHidden = false
                    self.addMoreLabel.isHidden = true
                }
            }
        }
        if let imageModel = viewModel as? ImageViewModeling {
            imageView.sd_setImage(with: imageModel.imageURL, completed: nil)
        }
        if let imageModel = viewModel as? ImageProviding {
            if let image = imageModel.image {
                imageView.image = image
            }
        }
    }
}
