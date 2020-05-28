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
    var selectedImage: String?
    var notSelectedImage: String?
    enum CodingKeys: String, CodingKey {
        case categoryId = "id"
        case categoryName = "name"
        case subCategories = "sub_categories"
        case selectedImage = "s_image"
        case notSelectedImage = "ns_image"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        categoryId = try values.decode(Int.self, forKey: .categoryId)
        categoryName = try values.decode(String.self, forKey: .categoryName)
        subCategories = try values.decode([SubCategory].self, forKey: .subCategories)
        selectedImage = try? values.decode(String.self, forKey: .selectedImage)
        notSelectedImage = try? values.decode(String.self, forKey: .notSelectedImage)

    }
}
