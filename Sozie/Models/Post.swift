//
//  Post.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/15/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct Post: Codable {
    var postId: Int
    var imageURL: String
    var user: User
    var userFollowedByMe: Bool?
//    var sizeType: String
    var sizeValue: String
    var reviews: Review?
    var canPostReview: Bool?
    enum CodingKeys: String, CodingKey {

        case postId = "id"
        case imageURL = "public_image_url"
        case user
        case userFollowedByMe = "poster_is_followed_by_me"
//        case sizeType = "size_type"
        case sizeValue = "size_worn"
        case reviews
        case canPostReview = "can_post_review"

    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        postId = try values.decode(Int.self, forKey: .postId)
        imageURL = try values.decode(String.self, forKey: .imageURL)
        user = try values.decode(User.self, forKey: .user)
        userFollowedByMe = try? values.decode(Bool.self, forKey: .userFollowedByMe)
//        sizeType = try values.decode(String.self, forKey: .sizeType)
        sizeValue = try values.decode(String.self, forKey: .sizeValue)
        reviews = try values.decode(Review.self, forKey: .reviews)
        canPostReview = try? values.decode(Bool.self, forKey: .canPostReview)
    }
}
