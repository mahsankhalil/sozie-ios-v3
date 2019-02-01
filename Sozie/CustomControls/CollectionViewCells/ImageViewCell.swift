//
//  ImageViewCell.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/30/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import SDWebImage
class ImageViewCell: UICollectionViewCell {
    @IBOutlet weak var imgVu: UIImageView!
    
    override func awakeFromNib() {
        self.applyShadowWith(radius: 10.0, shadowOffSet: CGSize(width: 0.0, height: 15.0), opacity: 0.25)
    }
}
extension ImageViewCell: CellConfigurable {
    func setup(_ viewModel: RowViewModel) {
        if let imgModel = viewModel as? ImageViewModeling {
            imgVu.sd_setImage(with: imgModel.imgURL, completed: nil)
        }

    }
}
