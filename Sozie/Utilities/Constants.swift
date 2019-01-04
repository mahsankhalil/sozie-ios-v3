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
}

public class Constant: NSObject {

    static let facebookURL = "https://graph.facebook.com/me"
    
    static let applicationName = "Sozie"
    static let serverDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    static let appDateFormat = "MM/dd/yyyy"
    static let eventDateFormat = "MM/dd/yyyy hh:mm a"
    static let eventDetailDateFormat = "MMM dd yyyy',' hh:mm a"
    static let animationDuration : TimeInterval = 0.5
  
//    static let serverURL = "https://api.connectin.tech/connectIn/api/v1/"
//    static let serverURL = "http://192.168.8.102:3000/connectIn/api/v1/"
  
    //MARK: - Response Keys
    
    static let messageKey = "message"
    static let responseKey = "responce"
    static let statusKey = "status"
    
    static let registrationURL = "signup"
//    static let loginURL = "signin"
    static let getProfileURL = "signin"
    static let socialLoginURL = "signin"
    
    
    // MARK: - API COnstants
    
    
    
}
