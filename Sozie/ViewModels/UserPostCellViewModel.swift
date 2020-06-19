//
//  UserPostCellViewModel.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 3/1/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct UserPostCellViewModel: RowViewModel, ImageViewModeling, SubtitleViewModeling, SelectionProviding {
    var subtitle: String?
    var imageURL: URL?
    var isSelected: Bool
    var status: String
}
struct UserPostWithUploadsViewModel: RowViewModel {
    var uploads: [Uploads]
    var isTutorial: Bool
    var isApproved: Bool
    var isModerated: Bool
    var productURL: String
    var postType: PostFilterType
    var videos: [VideoUploads]?
}
struct UploadViewModel: RowViewModel,VideoAvailabilityProviding {
    var imageURL: URL?
    var status: String
    var isApproved: Bool
    var isVideo: Bool?
    var videoURL: String?
}
