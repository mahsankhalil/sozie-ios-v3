//
//  Review.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 4/30/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct Review: Codable {
    var totalCount: Int
    var recent: [RecentReview]
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case recent
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        totalCount = try values.decode(Int.self, forKey: .totalCount)
        recent = try values.decode([RecentReview].self, forKey: .recent)
    }
}

struct RecentReview: Codable {
    var reviewId: Int
    var addedBy: ReviewUser
    var text: String
    var createdAt: String
    enum CodingKeys: String, CodingKey {
        case reviewId = "id"
        case addedBy = "added_by"
        case text
        case createdAt = "created_at"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        reviewId = try values.decode(Int.self, forKey: .reviewId)
        addedBy = try values.decode(ReviewUser.self, forKey: .addedBy)
        text = try values.decode(String.self, forKey: .text)
        createdAt = try values.decode(String.self, forKey: .createdAt)
    }
}

struct ReviewUser: Codable {
    var userId: Int
    var username: String
    var picture: String
    enum CodingKeys: String, CodingKey {
        case userId = "id"
        case username
        case picture = "public_picture_url"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userId = try values.decode(Int.self, forKey: .userId)
        username = try values.decode(String.self, forKey: .username)
        picture = try values.decode(String.self, forKey: .picture)
    }
}
