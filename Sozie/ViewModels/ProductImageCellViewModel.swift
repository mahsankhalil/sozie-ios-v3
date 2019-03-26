//
//  ProductImageCellViewModel.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/7/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct ProductImageCellViewModel: RowViewModel, TitleViewModeling, ImageViewModeling, TitleImageViewModeling, ReuseIdentifierProviding, CountViewModeling, DescriptionViewModeling, SelectionProviding {
    var isSelected: Bool
    var count: Int
    var title: String?
    var attributedTitle: NSAttributedString?
    var titleImageURL: URL?
    var imageURL: URL?
    var description: String?
    var reuseIdentifier = "ProductCell"

    init (isSelected: Bool, count: Int, title: String, attributedTitle: NSAttributedString?, titleImageURL: URL?, imageURL: URL?, description: String?, reuseIdentifier: String = "ProductCell") {
        self.isSelected = isSelected
        self.count = count
        self.title = title
        self.attributedTitle = attributedTitle
        self.titleImageURL = titleImageURL
        self.imageURL = imageURL
        self.description = description
        self.reuseIdentifier = reuseIdentifier
    }
    init(product: Product, identifier: String) {
        var imageURL = ""
        if product.brandId == 4 {
            if let productImageURL = product.merchantImageURL {
                if productImageURL.contains("|") {
                    let delimeter = "|"
                    let url = productImageURL.components(separatedBy: delimeter)
                    imageURL = url[0]
                }
            }
        } else {
            if let productImageURL = product.imageURL {
                imageURL = productImageURL.getActualSizeImageURL() ?? ""
            }
        }
        var brandImageURL = ""
        if let brandId = product.brandId {
            if let brand = UserDefaultManager.getBrandWithId(brandId: brandId) {
                brandImageURL = brand.titleImage
            }
        }
        var searchPrice = 0.0
        if let price = product.searchPrice {
            searchPrice = Double(price)
        }
        var postCount = 0
        if let count = product.postCount {
            postCount = count
        }
        var priceString = ""
        if let currency = product.currency?.getCurrencySymbol() {
            priceString = currency + " " + String(format: "%0.2f", searchPrice)
        }
        var productDescription = ""
        if let description = product.description {
            productDescription = description
        }
        self.isSelected = false
        self.count = postCount
        self.title = priceString
        self.titleImageURL = URL(string: brandImageURL)
        self.imageURL = URL(string: imageURL)
        description = productDescription
        reuseIdentifier = identifier
//        let viewModel = ProductImageCellViewModel(isSelected: false, count: postCount, title: priceString, attributedTitle: nil, titleImageURL: URL(string: brandImageURL), imageURL: URL(string: imageURL), description: productDescription, reuseIdentifier: "WishTableViewCell")
    }

    
}
