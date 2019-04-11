//
//  UserPost.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 3/1/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct UserPost: Codable {
    var postId: Int
    var imageURL: String
    var thumbURL: String
    var userId: Int
    var productId: String
    var sizeType: String
    var sizeValue: String
    var productRequest: Int?
    var product: Product

    enum CodingKeys: String, CodingKey {
        case postId = "id"
        case imageURL = "public_image_url"
        case userId = "user"
        case thumbURL = "public_thumb_image_url"
        case productId = "product_id"
        case sizeType = "size_type"
        case sizeValue = "size_value"
        case productRequest = "product_request"
        case product
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        postId = try values.decode(Int.self, forKey: .postId)
        imageURL = try values.decode(String.self, forKey: .imageURL)
        userId = try values.decode(Int.self, forKey: .userId)
        thumbURL = try values.decode(String.self, forKey: .thumbURL)
        productId = try values.decode(String.self, forKey: .productId)
        sizeType = try values.decode(String.self, forKey: .sizeType)
        sizeValue = try values.decode(String.self, forKey: .sizeValue)
        productRequest = try? values.decode(Int.self, forKey: .productRequest)
        product = try values.decode(Product.self, forKey: .product)
    }
}
struct PostPaginatedResponse: Codable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [UserPost]

    enum CodingKeys: String, CodingKey {
        case count
        case next
        case previous
        case results
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        count = try values.decode(Int.self, forKey: .count)
        next = try? values.decode(String.self, forKey: .next)
        previous = try? values.decode(String.self, forKey: .previous)
        results = try values.decode([UserPost].self, forKey: .results)
    }
}
