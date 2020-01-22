//
//  AdidasProduct.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/20/20.
//  Copyright © 2020 Danial Zahid. All rights reserved.
//

import UIKit
struct AdidasProductResponse: Codable {
    var rawStores: [AdidasStore]
    enum CodingKeys: String, CodingKey {
        case rawStores
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        rawStores = try values.decode([AdidasStore].self, forKey: .rawStores)
    }
}

struct AdidasStore: Codable {
    var storeId: String
    var name: String
    var street: String
    var city: String
    var country: String
    var avaialable: String
    var distance: String
    enum CodingKeys: String, CodingKey {
        case storeId = "id"
        case name
        case street = "street1"
        case city
        case country
        case avaialable = "Available"
        case distance
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        storeId = try values.decode(String.self, forKey: .storeId)
        name = try values.decode(String.self, forKey: .name)
        street = try values.decode(String.self, forKey: .street)
        city = try values.decode(String.self, forKey: .city)
        country = try values.decode(String.self, forKey: .country)
        avaialable = try values.decode(String.self, forKey: .avaialable)
        distance = try values.decode(String.self, forKey: .distance)

    }
}
