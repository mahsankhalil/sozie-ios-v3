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
    var country: Int?
    var type: String?
    var brand: Int?
    var firstName: String?
    var lastName: String?
    var socialId: String?
    var signUpMedium: String?
    var socialToken: String?
    var measurement: Measurements?
    var isFollowed: Bool?
    var preferences: UserPreferences?
    var isSuperUser: Bool?
    var isTutorialApproved: Bool?
    var tutorialCompleted: Bool?
    var createdAt: String?
    var isBanned: Bool?
    var sozieType: String?
    enum CodingKeys: String, CodingKey {
        case username
        case email
        case userId = "id"
        case gender
        case birthday
        case city
        case avatar
        case picture = "public_picture_url"
        case country
        case type
        case brand
        case measurement
        case firstName = "first_name"
        case lastName = "last_name"
        case socialId = "social_id"
        case signUpMedium = "signup_medium"
        case socialToken = "social_token"
        case isFollowed = "is_followed"
        case preferences
        case isSuperUser = "is_superuser"
        case isTutorialApproved = "tutorial_approved"
        case tutorialCompleted = "tutorial_completed"
        case createdAt = "created_at"
        case isBanned = "is_banned"
        case sozieType = "sozie_type"
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
        measurement = try? values.decode(Measurements.self, forKey: .measurement)
        isFollowed = try? values.decode(Bool.self, forKey: .isFollowed)
        preferences = try? values.decode(UserPreferences.self, forKey: .preferences)
        isSuperUser = try? values.decode(Bool.self, forKey: .isSuperUser)
        isTutorialApproved = try? values.decode(Bool.self, forKey: .isTutorialApproved)
        tutorialCompleted = try? values.decode(Bool.self, forKey: .tutorialCompleted)
        isBanned = try? values.decode(Bool.self, forKey: .isBanned)
        createdAt = try? values.decode(String.self, forKey: .createdAt)
        sozieType = try? values.decode(String.self, forKey: .sozieType)
    }
}
struct UserPreferences: Codable {
    var userId: Int
    var pushNotificationEnabled: Bool

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case pushNotificationEnabled = "enable_notifications"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userId = try values.decode(Int.self, forKey: .userId)
        pushNotificationEnabled = try values.decode(Bool.self, forKey: .pushNotificationEnabled)

    }
}
struct Measurements: Codable {
    var bra: Int?
    var height: Int?
    var bodyShape: String?
    var hip: Int?
    var cup: String?
    var waist: Int?
    var size: String?
    var unit: String?
    var chest: Int?
    var topSize: String?
    var bottomSize: String?

    enum CodingKeys: String, CodingKey {
        case bra
        case height
        case bodyShape = "body_shape"
        case hip
        case cup
        case waist
        case size
        case unit
        case chest
        case topSize = "top_size"
        case bottomSize = "bottom_size"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bra = try? values.decode(Int.self, forKey: .bra)
        height = try? values.decode(Int.self, forKey: .height)
        bodyShape = try? values.decode(String.self, forKey: .bodyShape)
        hip = try? values.decode(Int.self, forKey: .hip)
        cup = try? values.decode(String.self, forKey: .cup)
        waist = try? values.decode(Int.self, forKey: .waist)
        size = try? values.decode(String.self, forKey: .size)
        unit = try? values.decode(String.self, forKey: .unit)
        chest = try? values.decode(Int.self, forKey: .chest)
        topSize = try? values.decode(String.self, forKey: .topSize)
        bottomSize = try? values.decode(String.self, forKey: .bottomSize)
    }
}
