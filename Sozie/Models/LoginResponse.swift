//
//  LoginResponse.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/11/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct LoginResponse: Codable {

    var refresh : String
    var access : String
    var userId : Int
    
    enum CodingKeys: String, CodingKey {

        case refresh
        case access
        case userId = "user_id"
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        refresh = try values.decode(String.self, forKey: .refresh)
        access = try values.decode(String.self, forKey: .access)
        userId = try values.decode(Int.self, forKey: .userId)
        
    }
}
