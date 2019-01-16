
//
//  User.swift
//  Connectivity
//
//  Created by Danial Zahid on 24/09/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

struct User: Codable {
    
    var username: String?
    var email: String?
    var userId: Int?
    var gender: String?
    var birthday: String?
    var city: String?
    var avatar: String?
    var picture: String?
    var measurement : Measurement?
    
    enum CodingKeys: String, CodingKey {
        case username
        case email
        case userId = "user_id"
        case gender
        case birthday
        case city
        case avatar
        case picture
        case measurement
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        username = try values.decode(String.self, forKey: .username)
        email = try values.decode(String.self, forKey: .email)
        userId = try values.decode(Int.self, forKey: .userId)
        gender = try values.decode(String.self, forKey: .gender)
        birthday = try values.decode(String.self, forKey: .birthday)
        city = try values.decode(String.self, forKey: .city)
        avatar = try values.decode(String.self, forKey: .avatar)
        picture = try values.decode(String.self, forKey: .picture)
        measurement = try values.decode(Measurement.self, forKey: .measurement)
    }
}

struct Measurement: Codable {
    var bra: String?
    var height: String?
    var bodyShape: String?
    var hip: String?
    var cup: String?
    var waist: String?
    
    enum CodingKeys: String, CodingKey {
        case bra
        case height
        case bodyShape = "body_shape"
        case hip
        case cup
        case waist
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bra = try values.decode(String.self, forKey: .bra)
        height = try values.decode(String.self, forKey: .height)
        bodyShape = try values.decode(String.self, forKey: .bodyShape)
        hip = try values.decode(String.self, forKey: .hip)
        cup = try values.decode(String.self, forKey: .cup)
        waist = try values.decode(String.self, forKey: .waist)
    }
}
