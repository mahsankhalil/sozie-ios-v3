//
//  SozieCellViewModel.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/27/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct SozieCellViewModel: RowViewModel, FollowViewModeling, TitleViewModeling, TitleImageViewModeling, MeasurementViewModeling, ImageViewModeling {

    var isFollow: Bool?
    var title: String?
    var attributedTitle: NSAttributedString?
    var titleImageURL: URL?
    var bra: Int?
    var height: Int?
    var hip: Int?
    var cup: String?
    var waist: Int?
    var imageURL: URL?
}
