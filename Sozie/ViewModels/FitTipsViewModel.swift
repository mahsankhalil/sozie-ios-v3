//
//  FitTipsViewModel.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 7/3/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct FitTipsViewModel: RowViewModel, TitleViewModeling, SelectionProviding {
    var title: String?
    var attributedTitle: NSAttributedString?
    var isSelected: Bool
}
