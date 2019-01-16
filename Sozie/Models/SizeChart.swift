//
//  SizeChart.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/9/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct SizeChart: Codable {

    var general: [String]
    var height: Height
    var waist: [Int]
    var hip: [Int]
    var bra: Bra
    
    enum CodingKeys: String, CodingKey {
        case general
        case height
        case waist
        case hip
        case bra
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        general = try values.decode([String].self, forKey: .general)
        height = try values.decode(Height.self, forKey: .height)
        waist = try values.decode([Int].self, forKey: .waist)
        hip = try values.decode([Int].self, forKey: .hip)
        bra = try values.decode(Bra.self, forKey: .bra)

    }
}

struct Height: Codable {
    var inches: [Int]
    var feet: [Int]
    
    enum CodingKeys: String, CodingKey {
        case inches
        case feet
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        inches = try values.decode([Int].self, forKey: .inches)
        feet = try values.decode([Int].self, forKey: .feet)
    }
}

struct Bra: Codable {
    var cup: [String]
    var band: [Int]
    
    enum CodingKeys: String, CodingKey {
        case cup
        case band
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cup = try values.decode([String].self, forKey: .cup)
        band = try values.decode([Int].self, forKey: .band)
    }
}
