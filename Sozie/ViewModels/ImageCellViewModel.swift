//
//  ImageCellViewModel.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/7/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct ImageCellViewModel: RowViewModel, ImageViewModeling , ReuseIdentifierProviding {
    var imageURL: URL?
    let reuseIdentifier = "ImageViewCell"
}

