//
//  SocialAuthManager.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/18/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn

class SocialAuthManager: NSObject {

    static let sharedInstance = SocialAuthManager()

    public typealias CompletionHandler = ((Bool, Any) -> Void)?

    func loginWithFacebook(from viewController: UIViewController, block: CompletionHandler) {
        let loginManager = FBSDKLoginManager()
        loginManager.loginBehavior = FBSDKLoginBehavior.native
        loginManager.logIn(withReadPermissions: ["public_profile", "email"], from: viewController) { (result, error) in

            if error == nil {
                guard let token = result?.token else {
                    block!(false, CustomError(str: "Token is empty."))
                    return
                }

                // Verify token is not empty
                if token.tokenString.isEmpty {
                    print("Token is empty")
                    block!(false, CustomError(str: "Token is empty."))
                    return
                }

                guard let userId = token.userID else {
                    block!(false, CustomError(str: "UserId not found."))
                    return
                }

                let request = FBSDKGraphRequest(graphPath: "\(userId)",
                    parameters: ["fields": "id,name,first_name,last_name,email,birthday,gender,picture,link" ], httpMethod: "GET")
                request?.start(completionHandler: { (_, result, error) in
                    // Handle the result
                    if error == nil, let fbDict = result as? [String: Any] {
                        let dataDict = self.convertFacebookDictToAppDict(fbDict: fbDict, token: token.tokenString)
                        block!(true, dataDict)
                    } else {
                        block!(false, error!)
                    }
                })
            } else {
                block!(false, error!)
            }
        }
    }
    func convertFacebookDictToAppDict (fbDict: [String: Any], token: String) -> [String: Any] {
        var dataDict = [String: Any]()
        if let firstName = fbDict["first_name"] {
            dataDict[User.CodingKeys.firstName.stringValue] = firstName
        }
        if let lastName = fbDict["last_name"] {
            dataDict[User.CodingKeys.lastName.stringValue] = lastName
        }
        if let email = fbDict["email"] {
            dataDict[User.CodingKeys.email.stringValue] = email
        }
        if let birthday = fbDict["birthday"] {
            dataDict[User.CodingKeys.firstName.stringValue] = birthday
        }
        if let userId = fbDict["id"] {
            dataDict[User.CodingKeys.socialId.stringValue] = userId
        }
        dataDict[User.CodingKeys.socialToken.stringValue] = token
        dataDict[User.CodingKeys.signUpMedium.stringValue] = "FB"
        return dataDict
    }
    func convertGoogleUserToAppDict(user: GIDGoogleUser) -> [String: Any] {
        var dataDict = [String: String]()
        let fullName = user.profile.name
        var components = fullName?.components(separatedBy: " ")
        if((components?.count)! > 0) {
            let firstName = components?.removeFirst()
            let lastName = components?.joined(separator: " ")
            dataDict[User.CodingKeys.firstName.stringValue] = firstName
            dataDict[User.CodingKeys.lastName.stringValue] = lastName
        } else {
            dataDict[User.CodingKeys.firstName.stringValue] = user.profile.name
        }
        dataDict[User.CodingKeys.socialId.stringValue] = user.userID
        dataDict[User.CodingKeys.email.stringValue] = user.profile.email
        dataDict["image_path"] = user.profile.imageURL(withDimension: 200).absoluteString
        dataDict[User.CodingKeys.socialToken.stringValue] = user.authentication.accessToken
        dataDict[User.CodingKeys.signUpMedium.stringValue] = "GL"
        return dataDict
    }
}
