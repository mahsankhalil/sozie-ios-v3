//
//  Product.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/31/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct Product: Codable {
    var productId: Int
    var productName: String
    var deepLink: String
    var brand: Brand
    var searchPrice: Float
    var imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case productId = "id"
        case productName = "product_name"
        case deepLink = "service_deep_link"
        case brand = "sozie_brand"
        case searchPrice = "search_price"
        case imageURL = "service_image_url"

    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        productId = try values.decode(Int.self, forKey: .productId)
        productName = try values.decode(String.self, forKey: .productName)
        deepLink = try values.decode(String.self, forKey: .deepLink)
        brand = try values.decode(Brand.self, forKey: .brand)
        searchPrice = try values.decode(Float.self, forKey: .searchPrice)
        imageURL = try values.decode(String.self, forKey: .imageURL)
    }
}
