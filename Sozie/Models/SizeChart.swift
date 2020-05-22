//
//  SizeChart.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/9/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct AllSizes: Codable {
    var male: Size?
    var female: Size?
    enum CodingKeys: String, CodingKey {
    case male = "M"
    case female = "F"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        male = try? values.decode(Size.self, forKey: .male)
        female = try? values.decode(Size.self, forKey: .female)
    }
}
struct Size: Codable {

//    var general: [General]
    var height: Height
    var waist: IntegerScales
    var hip: IntegerScales
    var bra: Bra?
    var chest: IntegerScales?
    var sizes: [String]
    var topSizes: [String]?
    var bottomSizes: [String]?
//    var sizeChart: [SizeChart]
    enum CodingKeys: String, CodingKey {
//        case general
        case height
        case waist
        case hip
        case bra
//        case sizeChart = "size_chart"
        case chest
        case sizes
        case topSizes = "top_sizes"
        case bottomSizes = "bottom_sizes"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
//        general = try values.decode([General].self, forKey: .general)
        height = try values.decode(Height.self, forKey: .height)
        waist = try values.decode(IntegerScales.self, forKey: .waist)
        hip = try values.decode(IntegerScales.self, forKey: .hip)
        bra = try? values.decode(Bra.self, forKey: .bra)
//        sizeChart = try values.decode([SizeChart].self, forKey: .sizeChart)
        chest = try? values.decode(IntegerScales.self, forKey: .chest)
        sizes = try values.decode([String].self, forKey: .sizes)
        topSizes = try? values.decode([String].self, forKey: .topSizes)
        bottomSizes = try? values.decode([String].self, forKey: .bottomSizes)
    }
}
struct SizeChart: Codable {

    var usValue: String
    var ukValue: String
    var euValue: String
    var waist: Scales
    var hip: Scales
    var bust: Scales

    enum CodingKeys: String, CodingKey {
        case usValue = "US"
        case ukValue = "UK"
        case euValue = "EU"
        case waist = "WAIST"
        case hip = "HIPS"
        case bust = "BUST"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        usValue = try values.decode(String.self, forKey: .usValue)
        ukValue = try values.decode(String.self, forKey: .ukValue)
        euValue = try values.decode(String.self, forKey: .euValue)
        waist = try values.decode(Scales.self, forKey: .waist)
        hip = try values.decode(Scales.self, forKey: .hip)
        bust = try values.decode(Scales.self, forKey: .bust)
    }
}

struct IntegerScales: Codable {

    var inches: [Int]
    var centimeters: [Int]

    enum CodingKeys: String, CodingKey {
        case inches
        case centimeters
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        inches = try values.decode([Int].self, forKey: .inches)
        centimeters = try values.decode([Int].self, forKey: .centimeters)
    }
}
struct Scales: Codable {

    var inch: Double
    var centimeter: Double

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

struct General: Codable {

    var label: String
    var waist: Scales
    var hip: Scales
    var bust: Scales

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
    var centimeters: [Int]
    enum CodingKeys: String, CodingKey {
        case inches
        case feet
        case centimeters
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        inches = try values.decode([Int].self, forKey: .inches)
        feet = try values.decode([Int].self, forKey: .feet)
        centimeters = try values.decode([Int].self, forKey: .centimeters)
    }
}

struct Bra: Codable {

    var cup: [String]
    var band: IntegerScales

    enum CodingKeys: String, CodingKey {
        case cup
        case band
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cup = try values.decode([String].self, forKey: .cup)
        band = try values.decode(IntegerScales.self, forKey: .band)
    }
}
