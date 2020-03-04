//
//  StoreViewModel.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 5/30/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct StoreViewModel: RowViewModel, TitleViewModeling, DescriptionViewModeling, CountViewModeling {
    var count: Int
    var title: String?
    var attributedTitle: NSAttributedString?
    var description: String?
}

struct AdidasStoreViewModel: RowViewModel, TitleViewModeling, DescriptionViewModeling, CountViewModeling,AvailabilityProviding {
    var count: Int
    var title: String?
    var attributedTitle: NSAttributedString?
    var description: String?
    var isAvailable: Bool
}
