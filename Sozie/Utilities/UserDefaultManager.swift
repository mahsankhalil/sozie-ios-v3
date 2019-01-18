//
//  UserDefaultManager.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/16/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class UserDefaultManager: NSObject {

    
    private class func loginResponse() -> LoginResponse? {
        if let loginResponseData = UserDefaults.standard.data(forKey: UserDefaultKey.loginResponse) {
            let decoder = JSONDecoder()
            if let loginResponse = try? decoder.decode(LoginResponse.self, from: loginResponseData) {
                return loginResponse
            }
        }
        return nil
    }
    
    class func getCurrentUserObject() -> User?
    {
        if let loginResponse = UserDefaultManager.loginResponse()
        {
            return loginResponse.user
        }
        else
        {
            return nil
        }
    }
    
    class func getCurrentUserId() -> Int?
    {
        if let loginResponse = UserDefaultManager.loginResponse()
        {
            return loginResponse.user?.userId
        }
        else
        {
            return nil
        }
        
    }
    
    class func getAccessToken() -> String?
    {
        if let loginResponse = UserDefaultManager.loginResponse()
        {
            return loginResponse.access
        }
        else
        {
            return nil
        }
    }
    
    class func getRefreshToken() -> String?
    {
        if let loginResponse = UserDefaultManager.loginResponse()
        {
            return loginResponse.refresh
        }
        else
        {
            return nil
        }
        
    }
    
    class func saveLoginResponse(loginResp : LoginResponse) -> Bool
    {
        let encoder = JSONEncoder()
        if let loginResp = try? encoder.encode(loginResp)
        {
            UserDefaults.standard.set(loginResp, forKey: UserDefaultKey.loginResponse)
            UserDefaults.standard.synchronize()
            return true
        }
        
        return false
        
    }
    
}
