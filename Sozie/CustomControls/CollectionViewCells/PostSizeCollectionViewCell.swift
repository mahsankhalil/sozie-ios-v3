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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
    }
}
