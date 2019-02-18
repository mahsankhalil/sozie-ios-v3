//
//  LoginResponse.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/11/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct LoginResponse: Codable {

    var refresh: String
    var access: String
    var userId: Int?
    var user: User?
    
    enum CodingKeys: String, CodingKey {
        case refresh
        case access
        case userId = "user_id"
        case user
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        refresh = try values.decode(String.self, forKey: .refresh)
        access = try values.decode(String.self, forKey: .access)
        userId = try? values.decode(Int.self, forKey: .userId)
        user = try? values.decode(User.self, forKey: .user)
    }
}

struct ValidateRespose: Codable {
    
    var detail: String
    
    enum CodingKeys: String, CodingKey {
        case detail
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        detail = try values.decode(String.self, forKey: .detail)
    }
}

struct countResponse : Codable {
    var count: Int
    
    enum CodingKeys: String, CodingKey {
        case count
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        count = try values.decode(Int.self, forKey: .count)
    }
}


