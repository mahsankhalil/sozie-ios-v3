//
//  ProductCell.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/31/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgVuWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgVuHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var maskImageView: UIImageView!
    
    override func awakeFromNib() {
        productImageView.layer.cornerRadius = 5.0
        productImageView.clipsToBounds = true
        
    }
}

extension ProductCollectionViewCell: CellConfigurable {
    func setup(_ viewModel: RowViewModel) {
        if let imgModel = viewModel as? ImageViewModeling {
            productImageView.sd_setImage(with: imgModel.imageURL) { (img, err, cacheType, url) in
                self.adjustLayoutOfImageView()
                UIView.animate(withDuration: 0.3, animations: {
                    (self.superview as? UICollectionView)?.collectionViewLayout.invalidateLayout()
                })
            }
            self.adjustLayoutOfImageView()
        }
        if let titleImgModel = viewModel as? TitleImageViewModeling {
            titleImageView.sd_setImage(with: titleImgModel.titleImageURL, completed: nil)
        }
        if let titleModel = viewModel as? TitleViewModeling {
            priceLabel.text = "$ " + titleModel.title!
        }
        if let countModel = viewModel as? CountViewModeling {
            if countModel.count > 0 {
                maskImageView.isHidden = false
            } else {
                maskImageView.isHidden = true
            }
        }
    }
    
    func adjustLayoutOfImageView()
    {
        let width = (UIScreen.main.bounds.size.width - 44.0)/2
        if let img = productImageView.image {
            let aspectRatio = (img.size.height) / (img.size.width)
            let height = aspectRatio * width
            self.imgVuWidthConstraint.constant = width
            self.imgVuHeightConstraint.constant = height
        } else {
            self.imgVuWidthConstraint.constant = width
            self.imgVuHeightConstraint.constant = width
        }
    }
}
