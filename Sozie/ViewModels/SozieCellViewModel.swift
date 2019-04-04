//
//  SozieCellViewModel.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/27/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct SozieCellViewModel: RowViewModel, FollowViewModeling, TitleViewModeling, TitleImageViewModeling, MeasurementViewModeling, ImageViewModeling {

    var isFollow: Bool
    var title: String?
    var attributedTitle: NSAttributedString?
    var titleImageURL: URL?
    var bra: Int?
    var height: Int?
    var hip: Int?
    var cup: String?
    var waist: Int?
    var imageURL: URL?

    init (user: User, brandImageURL: String) {
        self.isFollow = user.isFollowed ?? false
        self.title = user.username
        self.titleImageURL = URL(string: brandImageURL)
        self.bra = user.measurement?.bra
        self.height = user.measurement?.height
        self.hip = user.measurement?.hip
        self.cup = user.measurement?.cup
        self.waist = user.measurement?.waist
    }
}
