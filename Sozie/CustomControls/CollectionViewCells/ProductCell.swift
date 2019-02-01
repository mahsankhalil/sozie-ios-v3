//
//  ProductCell.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/31/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class ProductCell: UICollectionViewCell {
    
    @IBOutlet weak var imgVuWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgVuHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleImgVu: UIImageView!
    @IBOutlet weak var productImgVu: UIImageView!
    @IBOutlet weak var priceLbl: UILabel!
    override func awakeFromNib() {
        productImgVu.layer.cornerRadius = 5.0
        productImgVu.clipsToBounds = true
        
    }
}


extension ProductCell: CellConfigurable {
    func setup(_ viewModel: RowViewModel) {
        if let imgModel = viewModel as? ImageViewModeling {
            productImgVu.sd_setImage(with: imgModel.imgURL) { (img, err, cacheType, url) in
                self.adjustLayoutOfImageView()
                UIView.animate(withDuration: 0.3, animations: {
                    (self.superview as? UICollectionView)?.collectionViewLayout.invalidateLayout()
                })
            }
            self.adjustLayoutOfImageView()
        }
        if let titleImgModel = viewModel as? TitleImgViewModeling {
            titleImgVu.sd_setImage(with: titleImgModel.titleImgURL, completed: nil)
        }
        if let titleModel = viewModel as? TitleViewModeling {
            priceLbl.text = titleModel.title
        }
    }
    
    func adjustLayoutOfImageView()
    {
        if let img = productImgVu.image {
            let aspectRatio = (img.size.height) / (img.size.width)
            let height = aspectRatio * (UIScreen.main.bounds.size.width - 44.0)/2
            self.imgVuWidthConstraint.constant = (UIScreen.main.bounds.size.width - 44.0)/2
            self.imgVuHeightConstraint.constant = height
        }
        else
        {
            
            self.imgVuWidthConstraint.constant = (UIScreen.main.bounds.size.width - 44.0)/2
            self.imgVuHeightConstraint.constant = (UIScreen.main.bounds.size.width - 44.0)/2
        }
    }
}
