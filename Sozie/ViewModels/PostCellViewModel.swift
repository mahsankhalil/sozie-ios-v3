//
//  PostCellViewModel.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/13/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct PostCellViewModel: RowViewModel, ImageViewModeling, TitleViewModeling, ReuseIdentifierProviding, MeasurementViewModeling, FollowViewModeling, DescriptionViewModeling {
    var isFollow: Bool
    var description: String?
    var bra: Int?
    var height: Int?
    var hip: Int?
    var cup: String?
    var waist: Int?
    var title: String?
    var attributedTitle: NSAttributedString?
    var imageURL: URL?
    let reuseIdentifier: String = "PostCollectionViewCell"

    init(post: Post) {
        self.title = post.user.username
        self.imageURL = URL(string: post.imageURL)
        self.bra = post.user.measurement?.bra
        self.height = post.user.measurement?.height
        self.hip = post.user.measurement?.hip
        self.cup = post.user.measurement?.cup
        self.waist = post.user.measurement?.waist
        self.isFollow = post.userFollowedByMe ?? false
        self.description = "Size Worn: " + post.sizeValue
    }
}
