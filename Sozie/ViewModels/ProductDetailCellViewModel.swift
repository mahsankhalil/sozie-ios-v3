//
//  ProductDetailCellViewModel.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/13/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct ProductDetailCellViewModel : RowViewModel , ImageViewModeling , TitleImageViewModeling , ReuseIdentifierProviding {
    var imageURL: URL?
    var titleImageURL: URL?
    let reuseIdentifier: String  = "ProductDetailCollectionViewCell"
}
