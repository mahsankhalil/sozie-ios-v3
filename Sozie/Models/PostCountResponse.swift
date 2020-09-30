//
//  PostCountResponse.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 9/30/20.
//  Copyright © 2020 Danial Zahid. All rights reserved.
//

import UIKit

struct PostCountResponse: Codable {
    var pendingCount: Int
    var rejectedCount: Int
    var approveCount: Int
    enum CodingKeys: String, CodingKey {
        case pendingCount = "pending_count"
        case rejectedCount = "approved_count"
        case approveCount = "rejected_count"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        pendingCount = try values.decode(Int.self, forKey: .pendingCount)
        rejectedCount = try values.decode(Int.self, forKey: .rejectedCount)
        approveCount = try values.decode(Int.self, forKey: .approveCount)
    }
}
