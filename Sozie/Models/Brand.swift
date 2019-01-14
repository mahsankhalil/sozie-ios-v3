//
//  Brand.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/10/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct Brand: Codable {
    var brandId : Int
    var createdAt : String
    var updatedAt : String
    var label : String
    var logo : String
    enum CodingKeys: String, CodingKey {
        
        case brandId = "id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case label
        case logo
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        brandId = try values.decode(Int.self, forKey: .brandId)
        createdAt = try values.decode(String.self, forKey: .createdAt)
        updatedAt = try values.decode(String.self, forKey: .updatedAt)
        label = try values.decode(String.self, forKey: .label)
        logo = try values.decode(String.self, forKey: .logo)

    }

}
