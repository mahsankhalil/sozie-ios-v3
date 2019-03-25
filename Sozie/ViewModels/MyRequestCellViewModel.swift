//
//  MyRequestCellViewModel.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/26/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct MyRequestCellViewModel: RowViewModel, TitleImageViewModeling, ImageViewModeling, TitleViewModeling, SelectionProviding, SubtitleViewModeling, PriceProviding {

    var price: String?
    var titleImageURL: URL?
    var imageURL: URL?
    var title: String?
    var attributedTitle: NSAttributedString?
    var isSelected: Bool
    var subtitle: String?
}
