//
//  ProductDetailCollectionViewCell.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/13/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class ProductDetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var brandImageView: UIImageView!
    @IBOutlet weak var productImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
extension ProductDetailCollectionViewCell: CellConfigurable {
    func setup(_ viewModel: RowViewModel) {
        if let imgModel = viewModel as? ImageViewModeling {
            productImageView.sd_setImage(with: imgModel.imageURL) { (_, _, _, _) in
            
            }
        }
        if let titleImgModel = viewModel as? TitleImageViewModeling {
            brandImageView.sd_setImage(with: titleImgModel.titleImageURL, completed: nil)
        }

    }
    
}
