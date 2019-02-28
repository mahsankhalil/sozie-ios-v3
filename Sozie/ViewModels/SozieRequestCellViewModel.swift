//
//  SozieRequestCellViewModel.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/28/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct SozieRequestCellViewModel: RowViewModel, TitleViewModeling, MeasurementViewModeling, ImageViewModeling, SelectionProviding, SubtitleViewModeling, DescriptionViewModeling {
    var description: String?
    var subtitle: String?
    var isSelected: Bool
    var title: String?
    var attributedTitle: NSAttributedString?
    var bra: Int?
    var height: Int?
    var hip: Int?
    var cup: String?
    var waist: Int?
    var imageURL: URL?
}
