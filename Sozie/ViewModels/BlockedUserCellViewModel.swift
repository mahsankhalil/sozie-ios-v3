//
//  BlockedUserCellViewModel.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 3/12/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct BlockedUserCellViewModel: RowViewModel, TitleViewModeling, ImageViewModeling {
    var title: String?
    var attributedTitle: NSAttributedString?
    var imageURL: URL?
}
