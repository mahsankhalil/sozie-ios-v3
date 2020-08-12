//
//  Category.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/8/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct Category: Codable {

    var categoryId: Int
    var categoryName: String
    var subCategories: [SubCategory]
    var femaleSelectedImage: String?
    var femaleNotSelectedImage: String?
    var maleSelectedImage: String?
    var maleNotSelectedImage: String?
    enum CodingKeys: String, CodingKey {
        case categoryId = "id"
        case categoryName = "name"
        case subCategories = "sub_categories"
        case femaleSelectedImage = "female_active_image"
        case femaleNotSelectedImage = "female_inactive_image"
        case maleSelectedImage = "male_active_image"
        case maleNotSelectedImage = "male_inactive_image"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        categoryId = try values.decode(Int.self, forKey: .categoryId)
        categoryName = try values.decode(String.self, forKey: .categoryName)
        subCategories = try values.decode([SubCategory].self, forKey: .subCategories)
        femaleSelectedImage = try? values.decode(String.self, forKey: .femaleSelectedImage)
        femaleNotSelectedImage = try? values.decode(String.self, forKey: .femaleNotSelectedImage)
        maleSelectedImage = try? values.decode(String.self, forKey: .maleSelectedImage)
        maleNotSelectedImage = try? values.decode(String.self, forKey: .maleNotSelectedImage)

    }
}
