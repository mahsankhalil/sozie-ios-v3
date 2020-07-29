//
//  TermsConditionViewModel.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 7/27/20.
//  Copyright © 2020 Danial Zahid. All rights reserved.
//

import UIKit

struct TermsConditionViewModel: RowViewModel, TitleViewModeling, SubtitleViewModeling, AvailabilityProviding {
    var title: String?
    var attributedTitle: NSAttributedString?
    var subtitle: String?
    var isAvailable: Bool
}
