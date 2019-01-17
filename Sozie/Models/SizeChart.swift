//
//  SizeChart.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/9/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct Size: Codable {

    var general : [General]
    var height : Height
    var waist : [Int]
    var hip : [Int]
    var bra : Bra
    var sizeChart : [SizeChart]

    enum CodingKeys: String, CodingKey {
        case general
        case height
        case waist
        case hip
        case bra
        case sizeChart = "size_chart"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        general = try values.decode([General].self, forKey: .general)
        height = try values.decode(Height.self, forKey: .height)
        waist = try values.decode([Int].self, forKey: .waist)
        hip = try values.decode([Int].self, forKey: .hip)
        bra = try values.decode(Bra.self, forKey: .bra)
        sizeChart = try values.decode([SizeChart].self, forKey: .sizeChart)
    }
}
struct SizeChart : Codable {
    
    var us : Int
    var uk : Int
    var eu : Int
    var waist : Scales
    var hip : Scales
    var bust : Scales
    
    enum CodingKeys: String, CodingKey {
        case us = "US"
        case uk = "UK"
        case eu = "EU"
        case waist = "WAIST"
        case hip = "HIPS"
        case bust = "BUST"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        us = try values.decode(Int.self, forKey: .us)
        uk = try values.decode(Int.self, forKey: .uk)
        eu = try values.decode(Int.self, forKey: .eu)
        waist = try values.decode(Scales.self, forKey: .waist)
        hip = try values.decode(Scales.self, forKey: .hip)
        bust = try values.decode(Scales.self, forKey: .bust)
    }
    
}

struct Scales : Codable {
    
    var inch : Double
    var centimeter : Double
    
    enum CodingKeys: String, CodingKey {
        case inch
        case centimeter
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        inch = try values.decode(Double.self, forKey: .inch)
        centimeter = try values.decode(Double.self, forKey: .centimeter)
    }
}



struct General : Codable {
    
    var label : String
    var waist : Scales
    var hip : Scales
    var bust : Scales
    
    enum CodingKeys: String, CodingKey {
        case label
        case waist = "WAIST"
        case hip = "HIPS"
        case bust = "BUST"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        label = try values.decode(String.self, forKey: .label)
        waist = try values.decode(Scales.self, forKey: .waist)
        hip = try values.decode(Scales.self, forKey: .hip)
        bust = try values.decode(Scales.self, forKey: .bust)
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
