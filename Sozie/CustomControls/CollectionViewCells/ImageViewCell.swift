//
//  ImageViewCell.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 5/28/20.
//  Copyright © 2020 Danial Zahid. All rights reserved.
//

import UIKit

class ImageViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
extension ImageViewCell: CellConfigurable {
    func setup(_ viewModel: RowViewModel) {
        if let currenttViewModel = viewModel as? ImageViewModel {
            self.imageView.image = UIImage(named: currenttViewModel.imageName ?? "")
        }
    }
}
