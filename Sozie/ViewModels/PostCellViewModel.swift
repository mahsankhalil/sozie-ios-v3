//
//  PostCellViewModel.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/13/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct PostCellViewModel : RowViewModel , ImageViewModeling , TitleViewModeling , ReuseIdentifierProviding {
    var title: String?
    var attributedTitle: NSAttributedString?
    var imageURL: URL?
    let reuseIdentifier: String = "PostCollectionViewCell"
}
