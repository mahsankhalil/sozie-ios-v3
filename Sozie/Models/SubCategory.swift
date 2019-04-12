//
//  SubCategory.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/8/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct SubCategory: Codable {
    var subCategoryId: Int
    var subCategoryName: String

    enum CodingKeys: String, CodingKey {
        case subCategoryId = "id"
        case subCategoryName = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        subCategoryId = try values.decode(Int.self, forKey: .subCategoryId)
        subCategoryName = try values.decode(String.self, forKey: .subCategoryName)
    }
}
