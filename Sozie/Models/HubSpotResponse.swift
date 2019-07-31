//
//  HubSpotResponse.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 7/23/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct HubSpotResponse: Codable {
    var vid: Int?
    var message: String?
    enum CodingKeys: String, CodingKey {
        case vid
        case message
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        vid = try? values.decode(Int.self, forKey: .vid)
        message = try? values.decode(String.self, forKey: .message)
    }
}
