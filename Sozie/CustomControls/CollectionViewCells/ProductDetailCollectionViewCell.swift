//
//  ProductDetailCollectionViewCell.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/13/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
protocol ProductDetailCollectionViewCellDelegate {
    func productCameraButtonTapped(button: UIButton)
}
class ProductDetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var brandImageView: UIImageView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    var delegate: ProductDetailCollectionViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if UserDefaultManager.getIfShopper() {
            cameraButton.isHidden = true
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if let _ = appDelegate.imageTaken {
                cameraButton.isHidden = true
            } else {
                cameraButton.isHidden = false
            }
        }
    }
    @IBAction func cameraButtonTapped(_ sender: Any) {
        delegate?.productCameraButtonTapped(button: sender as! UIButton)
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
