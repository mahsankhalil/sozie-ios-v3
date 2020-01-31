//
//  AdidasProduct.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/20/20.
//  Copyright © 2020 Danial Zahid. All rights reserved.
//

import UIKit
struct AdidasProductResponse: Codable {
    var filteredStores: [AdidasStore]
    enum CodingKeys: String, CodingKey {
        case filteredStores
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        filteredStores = try values.decode([AdidasStore].self, forKey: .filteredStores)
    }
}

struct AdidasStore: Codable {
    var storeId: String
    var name: String
    var street: String
    var city: String
    var avaialable: String
    enum CodingKeys: String, CodingKey {
        case storeId = "id"
        case name
        case street
        case city
        case avaialable = "availability"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        storeId = try values.decode(String.self, forKey: .storeId)
        name = try values.decode(String.self, forKey: .name)
        street = try values.decode(String.self, forKey: .street)
        city = try values.decode(String.self, forKey: .city)
        avaialable = try values.decode(String.self, forKey: .avaialable)
    }
}
