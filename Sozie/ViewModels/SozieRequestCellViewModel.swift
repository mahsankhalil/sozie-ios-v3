//
//  SozieRequestCellViewModel.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/28/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct SozieRequestCellViewModel: RowViewModel, TitleViewModeling, MeasurementViewModeling, ImageViewModeling, SelectionProviding, SubtitleViewModeling, DescriptionViewModeling, AvailabilityProviding, BrandIdProviding, FilledViewModeling, ExpiryViewModeling, ColorViewModeling, ProductIdProviding, PriceProviding {
    var brandId: Int
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
    var isFilled: Bool
    var expiry: String
    var acceptedBySomeoneElse: Bool
    var colorTitle: String?
    var productId: String
    var price: String?
    init (request: SozieRequest) {
        var imageURL = ""
        if let productImageURL = request.requestedProduct?.imageURL {
            imageURL = productImageURL.getActualSizeImageURL() ?? ""
        }
        if let feedId = request.requestedProduct?.feedId {
            if feedId == 18857 {
                if let merchantImageURL = request.requestedProduct?.merchantImageURL {
                    let delimeter = "|"
                    let url = merchantImageURL.components(separatedBy: delimeter)
                    imageURL = url[0]
                }
            }
        }
        var subtitle = "Size: " + request.sizeValue.uppercased()
        if let displaySize = request.displaySize {
            subtitle = "Size: " + displaySize.uppercased().sizeMap()
        }
        if let color = request.color {
            self.colorTitle = UtilityManager.getColorNameCapitalized(color: color)
        } else {
            self.colorTitle = "Color: N/A"
        }
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
        self.isAvailable = request.user.isSuperUser ?? false
        self.brandId = request.brandId
        self.isFilled = request.isFilled
        self.acceptedBySomeoneElse = false
        if let acceptedRequest = request.acceptedRequest {
            self.expiry = acceptedRequest.expiry ?? ""
            if acceptedRequest.acceptedById == UserDefaultManager.getCurrentUserId() {
                self.acceptedBySomeoneElse = false
            } else {
                self.acceptedBySomeoneElse = true
            }
        } else {
            self.expiry = ""
        }
        self.productId = request.requestedProduct?.productStringId ?? ""
        if let price = request.requestedProduct?.searchPrice, let currency = request.requestedProduct?.currency {
            self.price = currency + String(price)
        }
    }
}
