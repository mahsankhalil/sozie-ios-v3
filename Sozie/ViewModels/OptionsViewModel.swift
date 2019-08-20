//
//  OptionsViewModel.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 7/4/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct OptionsViewModel: RowViewModel, TitleViewModeling, CheckmarkViewModeling {
    var title: String?
    var attributedTitle: NSAttributedString?
    var isCheckmarkHidden: Bool
    let isFromFitTips = true
}
