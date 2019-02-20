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

    enum CodingKeys: String, CodingKey {

        case postId = "id"
        case imageURL = "image"
        case user
        case userFollowedByMe = "poster_is_followed_by_me"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        postId = try values.decode(Int.self, forKey: .postId)
        imageURL = try values.decode(String.self, forKey: .imageURL)
        user = try values.decode(User.self, forKey: .user)
        userFollowedByMe = try? values.decode(Bool.self, forKey: .userFollowedByMe)

    }
}
