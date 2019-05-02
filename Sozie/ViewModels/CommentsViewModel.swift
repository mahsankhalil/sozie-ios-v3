//
//  CommentsViewModel.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 4/30/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct CommentsViewModel: RowViewModel, TitleViewModeling, DescriptionViewModeling, ImageViewModeling {
    var title: String?
    var attributedTitle: NSAttributedString?
    var description: String?
    var imageURL: URL?
    let reuseIdentifier = "CommentCell"
}
