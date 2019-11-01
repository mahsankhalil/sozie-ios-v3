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
    var user: User
//    var sizeType: String
    var sizeValue: String
    var productId: String
    var requestedProduct: Product
    var brandId: Int
    var isFilled: Bool
    var isAccepted: Bool
    var acceptedRequest: AcceptedRequest?
    var color: String?
    enum CodingKeys: String, CodingKey {
        case requestId = "id"
        case user = "user"
//        case sizeType = "size_type"
        case sizeValue = "size_worn"
        case productId = "product_id"
        case requestedProduct = "requested_product"
        case brandId = "brand"
        case isFilled = "is_filled"
        case isAccepted = "is_accepted"
        case acceptedRequest = "accepted_request"
        case color
    }
    init(requestId: Int, user: User, sizeValue: String, productId: String, requestedProduct: Product, brandId: Int, isFilled: Bool, isAccepted: Bool, acceptedRequest: AcceptedRequest?, color: String?) {
        self.requestId = requestId
        self.user = user
        self.sizeValue = sizeValue
        self.productId = productId
        self.requestedProduct = requestedProduct
        self.brandId = brandId
        self.isFilled = isFilled
        self.isAccepted = isAccepted
        self.acceptedRequest = acceptedRequest
        self.color = color
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        requestId = try values.decode(Int.self, forKey: .requestId)
        user = try values.decode(User.self, forKey: .user)
//        sizeType = try values.decode(String.self, forKey: .sizeType)
        sizeValue = try values.decode(String.self, forKey: .sizeValue)
        productId = try values.decode(String.self, forKey: .productId)
        requestedProduct = try values.decode(Product.self, forKey: .requestedProduct)
        brandId = try values.decode(Int.self, forKey: .brandId)
        isFilled = try values.decode(Bool.self, forKey: .isFilled)
        isAccepted = try values.decode(Bool.self, forKey: .isAccepted)
        acceptedRequest = try? values.decode(AcceptedRequest.self, forKey: .acceptedRequest)
        color = try? values.decode(String.self, forKey: .color)

    }
}

struct AcceptedRequest: Codable {
    var acceptedId: Int?
    var acceptedById: Int?
    var expiry: String?
    enum CodingKeys: String, CodingKey {
        case acceptedId = "id"
        case acceptedById = "accepted_by"
        case expiry
    }
    init(acceptedById: Int, acceptedId: Int, expiry: String) {
        self.acceptedId = acceptedId
        self.acceptedById = acceptedById
        self.expiry = expiry
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        acceptedId = try? values.decode(Int.self, forKey: .acceptedId)
        acceptedById = try? values.decode(Int.self, forKey: .acceptedById)
        expiry = try? values.decode(String.self, forKey: .expiry)
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
