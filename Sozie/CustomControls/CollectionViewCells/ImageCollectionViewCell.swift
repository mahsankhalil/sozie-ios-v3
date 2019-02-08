//
//  ImageViewCell.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/30/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import SDWebImage
class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        self.applyShadowWith(radius: 10.0, shadowOffSet: CGSize(width: 0.0, height: 15.0), opacity: 0.25)
    }
}
extension ImageCollectionViewCell: CellConfigurable {
    func setup(_ viewModel: RowViewModel) {
        if let imageModel = viewModel as? ImageViewModeling {
            imageView.sd_setImage(with: imageModel.imageURL, completed: nil)
        }

    }
}
