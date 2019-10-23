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
//    var imageURL: String
//    var thumbURL: String?
    var userId: Int
    var productId: String
    var sizeValue: String
//    var productRequest: Int?
//    var product: Product
//    var reviewAction: String
    var isApproved: Bool
    var uploads: [Uploads]
    var isTutorialPost: Bool
    var isModerated: Bool

    enum CodingKeys: String, CodingKey {
        case postId = "id"
//        case imageURL = "public_image_url"
        case userId = "user"
//        case thumbURL = "public_thumb_image_url"
        case productId = "product_id"
        case sizeValue = "size_worn"
//        case productRequest = "product_request"
//        case product
//        case reviewAction = "review_action"
        case isApproved = "is_approved"
        case uploads
        case isTutorialPost = "posted_to_learn"
        case isModerated = "is_moderated"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        postId = try values.decode(Int.self, forKey: .postId)
//        imageURL = try values.decode(String.self, forKey: .imageURL)
        userId = try values.decode(Int.self, forKey: .userId)
//        thumbURL = try? values.decode(String.self, forKey: .thumbURL)
        productId = try values.decode(String.self, forKey: .productId)
        sizeValue = try values.decode(String.self, forKey: .sizeValue)
//        productRequest = try? values.decode(Int.self, forKey: .productRequest)
//        product = try values.decode(Product.self, forKey: .product)
//        reviewAction = try values.decode(String.self, forKey: .reviewAction)
        isApproved = try values.decode(Bool.self, forKey: .isApproved)
        uploads = try values.decode([Uploads].self, forKey: .uploads)
        isTutorialPost = try values.decode(Bool.self, forKey: .isTutorialPost)
        isModerated = try values.decode(Bool.self, forKey: .isModerated)
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
struct Uploads: Codable {
    var uploadId: Int
    var postId: Int
    var imageURL: String
    var reviewAction: String
    var isApproved: Bool

    enum CodingKeys: String, CodingKey {
        case uploadId = "id"
        case postId = "post"
        case imageURL = "public_image_url"
        case reviewAction = "review_action"
        case isApproved = "is_approved"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uploadId = try values.decode(Int.self, forKey: .uploadId)
        postId = try values.decode(Int.self, forKey: .postId)
        imageURL = try values.decode(String.self, forKey: .imageURL)
        reviewAction = try values.decode(String.self, forKey: .reviewAction)
        isApproved = try values.decode(Bool.self, forKey: .isApproved)
    }
}
