
//
//  User.swift
//  Connectivity
//
//  Created by Danial Zahid on 24/09/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

struct User: Codable {

    var username: String
    var email: String
    var userId: Int
    var gender: String
    var birthday: String
    var city: String?
    var avatar: String?
    var picture: String?
    var country : Int?
    var type : String?
    var brand : Int?
    var firstName : String?
    var lastName : String?
    var socialId : String?
    var signUpMedium : String?
    var socialToken : String?
    var measurement : Measurement?
    
    enum CodingKeys: String, CodingKey {
        case username
        case email
        case userId = "id"
        case gender
        case birthday
        case city
        case avatar
        case picture
        case country
        case type
        case brand
        case measurement
        case firstName = "first_name"
        case lastName = "last_name"
        case socialId = "social_id"
        case signUpMedium = "signup_medium"
        case socialToken = "social_token"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        username = try values.decode(String.self, forKey: .username)
        email = try values.decode(String.self, forKey: .email)
        userId = try values.decode(Int.self, forKey: .userId)
        gender = try values.decode(String.self, forKey: .gender)
        birthday = try values.decode(String.self, forKey: .birthday)
        city = try? values.decode(String.self, forKey: .city)
        avatar = try? values.decode(String.self, forKey: .avatar)
        picture = try? values.decode(String.self, forKey: .picture)
        country = try? values.decode(Int.self, forKey: .country)
        type = try? values.decode(String.self, forKey: .type)
        brand = try? values.decode(Int.self, forKey: .brand)
        firstName = try? values.decode(String.self, forKey: .firstName)
        lastName = try? values.decode(String.self, forKey: .lastName)
        socialId = try? values.decode(String.self, forKey: .socialId)
        socialToken = try? values.decode(String.self, forKey: .socialToken)
        signUpMedium = try? values.decode(String.self, forKey: .signUpMedium)

        measurement = try? values.decode(Measurement.self, forKey: .measurement)
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
    
    init() {
        
    }
}


class LocalMeasurement: NSObject {
    var bra: String?
    var height: String?
    var bodyShape: String?
    var hip: String?
    var cup: String?
    var waist: String?

}
