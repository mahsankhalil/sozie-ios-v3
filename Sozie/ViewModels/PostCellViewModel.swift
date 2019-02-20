//
//  PostCellViewModel.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/13/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct PostCellViewModel : RowViewModel , ImageViewModeling , TitleViewModeling , ReuseIdentifierProviding , MeasurementViewModeling, FollowViewModeling {
    var isFollow: Bool?
    var bra: Int?
    var height: Int?
    var hip: Int?
    var cup: String?
    var waist: Int?
    var title: String?
    var attributedTitle: NSAttributedString?
    var imageURL: URL?
    var index: Int?
    let reuseIdentifier: String = "PostCollectionViewCell"
}
