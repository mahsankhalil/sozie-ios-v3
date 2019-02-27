//
//  SozieRequest.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/26/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct SozieRequest: Codable {
    var requestId: Int
    var userId: Int
    var sizeType: String
    var sizeValue: String
    var productId: String
    var requestedProduct: Product
    var brandId: Int
    var isFilled: Bool

    enum CodingKeys: String, CodingKey {
        case requestId = "id"
        case userId = "user"
        case sizeType = "size_type"
        case sizeValue = "size_value"
        case productId = "product_id"
        case requestedProduct = "requested_product"
        case brandId = "brand"
        case isFilled = "is_filled"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        requestId = try values.decode(Int.self, forKey: .requestId)
        userId = try values.decode(Int.self, forKey: .userId)
        sizeType = try values.decode(String.self, forKey: .sizeType)
        sizeValue = try values.decode(String.self, forKey: .sizeValue)
        productId = try values.decode(String.self, forKey: .productId)
        requestedProduct = try values.decode(Product.self, forKey: .requestedProduct)
        brandId = try values.decode(Int.self, forKey: .brandId)
        isFilled = try values.decode(Bool.self, forKey: .isFilled)
    }

}

struct RequestsPaginatedResponse: Codable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [SozieRequest]

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
        results = try values.decode([SozieRequest].self, forKey: .results)
    }
}
