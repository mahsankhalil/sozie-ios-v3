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
import AuthenticationServices
class SocialAuthManager: NSObject {

    static let sharedInstance = SocialAuthManager()

    public typealias CompletionHandler = ((Bool, Any) -> Void)?

    func loginWithFacebook(from viewController: UIViewController, block: CompletionHandler) {
        let loginManager = LoginManager()
        loginManager.logOut()
//        loginManager.loginBehavior = LoginBehavior.native
        loginManager.logIn(permissions: ["public_profile", "email"], from: viewController) { (result, error) in

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

//                if token.userID == nil {
//                    block!(false, CustomError(str: "UserId not found."))
//                    return
//                }
                let request = GraphRequest(graphPath: "\(token.userID)",
                    parameters: ["fields": "id,name,first_name,last_name,email,birthday,gender,picture,link" ], httpMethod: HTTPMethod(rawValue: "GET"))
                request.start(completionHandler: { (_, result, error) in
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
        if (components?.count)! > 0 {
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
    @available (iOS 13, *)
    func convertAppleUserToAppDict(user: ASAuthorizationAppleIDCredential) -> [String: Any] {
        var dataDict = [String: String]()
        let userId = user.user
        var userFirstName = user.fullName?.givenName
        var userLastName = user.fullName?.familyName
        var userEmail = user.email
        if user.email == nil {
            let keychain = UserDataKeychain()
            do {
                let userData = try keychain.retrieve()
                userEmail = userData.email
                userFirstName = userData.name.givenName
                userLastName = userData.name.familyName
            } catch {
            }
        } else {
            saveUserDataOnKeychain(user: user)
        }
        dataDict[User.CodingKeys.socialId.stringValue] = userId
        dataDict[User.CodingKeys.firstName.stringValue] = userFirstName
        dataDict[User.CodingKeys.lastName.stringValue] = userLastName
        dataDict[User.CodingKeys.email.stringValue] = userEmail
        if let token = user.identityToken {
            dataDict[User.CodingKeys.socialToken.stringValue] = String(decoding: token, as: UTF8.self)
        }
        dataDict[User.CodingKeys.signUpMedium.stringValue] = "AP"
        return dataDict
    }
    @available (iOS 13, *)
    func saveUserDataOnKeychain(user: ASAuthorizationAppleIDCredential) {
        let userData = UserData(email: user.email!,
                                name: user.fullName!,
                                identifier: user.user)
        let keychain = UserDataKeychain()
        do {
          try keychain.store(userData)
        } catch {
        }
    }
}
