//
//  Brand.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/10/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct Brand: Codable {
    
    var brandId: Int
    var label: String
    var logo: String
    var titleImage: String
    var titleImageCentred: String?
    enum CodingKeys: String, CodingKey {
        case brandId = "id"
        case label
        case logo
        case titleImage = "title_image"
        case titleImageCentred = "title_image_centered"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        brandId = try values.decode(Int.self, forKey: .brandId)
        label = try values.decode(String.self, forKey: .label)
        logo = try values.decode(String.self, forKey: .logo)
        titleImage = try values.decode(String.self, forKey: .titleImage)
        titleImageCentred = try? values.decode(String.self, forKey: .titleImageCentred)
    }
}
