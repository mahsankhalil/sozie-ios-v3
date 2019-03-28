//
//  Country.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/11/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct Country: Codable {
    var countryId: Int
    var name: String
    var code: String
    
    enum CodingKeys: String, CodingKey {
        case countryId = "id"
        case name
        case code
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        countryId = try values.decode(Int.self, forKey: .countryId)
        name = try values.decode(String.self, forKey: .name)
        code = try values.decode(String.self, forKey: .code)
    }
}
