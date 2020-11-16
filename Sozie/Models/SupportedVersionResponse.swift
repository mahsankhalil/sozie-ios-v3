//
//  SupportedVersionResponse.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 11/16/20.
//  Copyright © 2020 Danial Zahid. All rights reserved.
//

import UIKit

struct SupportedVersionResponse: Codable {
    var ios: Platform
    var android: Platform
    enum CodingKeys: String, CodingKey {
        case ios
        case android
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ios = try values.decode(Platform.self, forKey: .ios)
        android = try values.decode(Platform.self, forKey: .android)
    }
}

struct Platform: Codable {
    var supportedVersion: String
    enum CodingKeys: String, CodingKey {
        case supportedVersion = "supported_version"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        supportedVersion = try values.decode(String.self, forKey: .supportedVersion)
    }
}
