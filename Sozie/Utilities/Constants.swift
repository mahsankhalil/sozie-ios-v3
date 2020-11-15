//
//  Constants.swift
//  Quicklic
//
//  Created by Danial Zahid on 30/07/2015.
//  Copyright (c) 2015 Danial Zahid. All rights reserved.
//

import UIKit

public class UserDefaultKey: NSObject {
    static let sessionID = "session"
    static let pushNotificationToken = "pushNotificationToken"
    static let geoFeedRadius = "radiusValueForFeed"
    static let ownPostsFilter = "ownPostsFilter"
    static let linkedInAuthKey = "linkedInAuthKey"
    static let accessToken = "access"
    static let refreshToken = "refresh"
    static let userId = "user_id"
    static let loginResponse = "loginResponse"
    static let brands = "brands"
    static let userGuide = "userGuide"
    static let measurementUserGuide = "mesurementUserGuide"
    static let browseUserGuide = "browseUserGuide"
    static let requestSozieButtonUserGuide = "requestSozieButtonUserGuide"
    static let followButtonUserGuide = "followButtonUserGuide"
    static let mySoziesUserGuide = "mySoziesUserGuide"
    static let myRequestsUserGuide = "myRequestsUserGuide"
    static let sozieCode = "sozie_code"
}

public class Constant: NSObject {

    static let facebookURL = "https://graph.facebook.com/me"
    static let applicationName = "Sozie"
    static let serverDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    static let appDateFormat = "MM/dd/yyyy"
    static let eventDateFormat = "MM/dd/yyyy hh:mm a"
    static let eventDetailDateFormat = "MMM dd yyyy',' hh:mm a"
    static let animationDuration: TimeInterval = 0.5

    static let single = "single"
    static let double = "double"
}
