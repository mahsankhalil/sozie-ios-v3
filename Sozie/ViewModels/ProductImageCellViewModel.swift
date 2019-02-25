//
//  ProductImageCellViewModel.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/7/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct ProductImageCellViewModel: RowViewModel, TitleViewModeling, ImageViewModeling, TitleImageViewModeling, ReuseIdentifierProviding, CountViewModeling, DescriptionViewModeling {
    var count: Int
    var title: String?
    var attributedTitle: NSAttributedString?
    var titleImageURL: URL?
    var imageURL: URL?
    var description : String?
    var reuseIdentifier = "ProductCell"
    
}
