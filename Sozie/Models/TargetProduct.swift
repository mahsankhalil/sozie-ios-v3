//
//  TargetProduct.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 5/28/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct ProductResponse: Codable {
    var products: [TargetProduct]
    enum CodingKeys: String, CodingKey {
        case products
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        products = try values.decode([TargetProduct].self, forKey: .products)
    }
    
}
struct TargetProduct: Codable {
    var productId: String
    var streetDate: String
    var availableToPurchateDate: String
    var locations: [TargetLocation]
    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case streetDate = "street_date"
        case availableToPurchateDate = "available_to_purchase_date_time"
        case locations
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        productId = try values.decode(String.self, forKey: .productId)
        streetDate = try values.decode(String.self, forKey: .streetDate)
        availableToPurchateDate = try values.decode(String.self, forKey: .availableToPurchateDate)
        locations = try values.decode([TargetLocation].self, forKey: .locations)
    }
}

struct TargetLocation: Codable {
    var locationId: String
    var distance: String
    var storeName: String
    var storeAddress: String
    var locationAvailableQuantity: Int
    var storePickupAvailability: Availability
    var curbsideAvailability: Availability
    var inStoreOnly: Availability
    enum CodingKeys: String, CodingKey {
        case locationId = "location_id"
        case distance = "distance"
        case storeName = "store_name"
        case storeAddress = "store_address"
        case locationAvailableQuantity = "location_available_to_promise_quantity"
        case storePickupAvailability = "store_pickup"
        case curbsideAvailability = "curbside"
        case inStoreOnly = "in_store_only"

    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        locationId = try values.decode(String.self, forKey: .locationId)
        distance = try values.decode(String.self, forKey: .distance)
        storeName = try values.decode(String.self, forKey: .storeName)
        storeAddress = try values.decode(String.self, forKey: .storeAddress)
        locationAvailableQuantity = try values.decode(Int.self, forKey: .locationAvailableQuantity)
        storePickupAvailability = try values.decode(Availability.self, forKey: .storePickupAvailability)
        curbsideAvailability = try values.decode(Availability.self, forKey: .curbsideAvailability)
        inStoreOnly = try values.decode(Availability.self, forKey: .inStoreOnly)
    }
}

struct Availability: Codable {
    var availabilityStatus: String
    var pickupDate: String?
    enum CodingKeys: String, CodingKey {
        case availabilityStatus = "availability_status"
        case pickupDate = "pickup_date"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        availabilityStatus = try values.decode(String.self, forKey: .availabilityStatus)
        pickupDate = try? values.decode(String.self, forKey: .pickupDate)
    }
}
