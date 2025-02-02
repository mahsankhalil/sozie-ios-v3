//
//  ProductSizeChart.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/22/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

//struct ProductSizeChart: Codable {
////    var generalSize: [HasPost]
////    var ukSize: [HasPost]
////    var usSize: [HasPost]
//    var size: HasPost
//
//    enum CodingKeys: String, CodingKey {
//        case generalSize = "GN"
//        case ukSize = "UK"
//        case usSize = "US"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        generalSize = try values.decode([HasPost].self, forKey: .generalSize)
//        ukSize = try values.decode([HasPost].self, forKey: .ukSize)
//        usSize = try values.decode([HasPost].self, forKey: .usSize)
//
//    }
//}
struct ProductSize: Codable {
    var name: String
    var hasPosts: Bool
    var inStock: Bool

    enum CodingKeys: String, CodingKey {
        case name
        case hasPosts = "has_posts"
        case inStock = "in_stock"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        hasPosts = try values.decode(Bool.self, forKey: .hasPosts)
        inStock = try values.decode(Bool.self, forKey: .inStock)
    }
}
