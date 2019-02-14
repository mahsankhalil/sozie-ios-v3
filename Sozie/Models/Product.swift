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
    var brandId: Int
    var searchPrice: Float
    var imageURL: String
    var description : String
    var categoryId : Int
    var postCount : Int
    var currency : String
    
    enum CodingKeys: String, CodingKey {
        case productId = "id"
        case productName = "product_name"
        case deepLink = "service_deep_link"
        case brandId = "sozie_brand_id"
        case searchPrice = "search_price"
        case imageURL = "service_image_url"
        case description
        case categoryId = "generic_category"
        case postCount = "posts"
        case currency
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        productId = try values.decode(Int.self, forKey: .productId)
        productName = try values.decode(String.self, forKey: .productName)
        deepLink = try values.decode(String.self, forKey: .deepLink)
        brandId = try values.decode(Int.self, forKey: .brandId)
        searchPrice = try values.decode(Float.self, forKey: .searchPrice)
        imageURL = try values.decode(String.self, forKey: .imageURL)
        description = try values.decode(String.self, forKey: .description)
        categoryId = try values.decode(Int.self, forKey: .categoryId)
        postCount = try values.decode(Int.self, forKey: .postCount)
        currency = try values.decode(String.self, forKey: .currency)
    }
}
