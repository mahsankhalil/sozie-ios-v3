//
//  SizeCellViewModel.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/22/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct SizeCellViewModel: RowViewModel, TitleViewModeling, SelectionProviding {
    var isSelected: Bool
    var title: String?
    var attributedTitle: NSAttributedString?
}
