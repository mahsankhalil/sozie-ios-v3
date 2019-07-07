//
//  UploadPictureViewModel.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 7/2/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct UploadPictureViewModel: RowViewModel, TitleViewModeling, ImageViewModeling, ImageProviding {
    var title: String?
    var attributedTitle: NSAttributedString?
    var imageURL: URL?
    var image: UIImage?
}
