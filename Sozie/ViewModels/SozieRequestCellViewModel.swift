//
//  SozieRequestCellViewModel.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/28/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct SozieRequestCellViewModel: RowViewModel, TitleViewModeling, MeasurementViewModeling, ImageViewModeling, SelectionProviding, SubtitleViewModeling, DescriptionViewModeling, AvailabilityProviding {
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
    var isAvailable: Bool

    init (request: SozieRequest) {
        var imageURL = ""
        if let productImageURL = request.requestedProduct.imageURL {
            imageURL = productImageURL.getActualSizeImageURL() ?? ""
        }
        if let feedId = request.requestedProduct.feedId {
            if feedId == 18857 {
                if let merchantImageURL = request.requestedProduct.merchantImageURL {
                    let delimeter = "|"
                    let url = merchantImageURL.components(separatedBy: delimeter)
                    imageURL = url[0]
                }
            }
        }
        let subtitle = "Size Requested: (" + request.sizeValue + ")"
        let title = "Requested by " + request.user.username
        let description = request.user.username +  " Measurements:"
        self.description = description
        self.subtitle = subtitle
        self.isSelected = request.isAccepted
        self.title = title
        self.bra = request.user.measurement?.bra
        self.height = request.user.measurement?.height
        self.hip = request.user.measurement?.hip
        self.cup = request.user.measurement?.cup
        self.waist = request.user.measurement?.waist
        self.imageURL = URL(string: imageURL)
        if request.user.isSuperUser == true {
            self.isAvailable = true
        } else {
            self.isAvailable = false
        }
    }
}
