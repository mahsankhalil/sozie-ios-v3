//
//  ReferalResponse.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 6/26/20.
//  Copyright © 2020 Danial Zahid. All rights reserved.
//

import UIKit

struct ReferalResponse: Codable {

    var codeId: Int
    var belongTo: Int
    var code: String
    var userFrequency: Int

    enum CodingKeys: String, CodingKey {
        case codeId = "id"
        case belongTo = "belong_to"
        case code
        case userFrequency = "use_frequency"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        codeId = try values.decode(Int.self, forKey: .codeId)
        belongTo = try values.decode(Int.self, forKey: .belongTo)
        code = try values.decode(String.self, forKey: .code)
        userFrequency = try values.decode(Int.self, forKey: .userFrequency)

    }
}
