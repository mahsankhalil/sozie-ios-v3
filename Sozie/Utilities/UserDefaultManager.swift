//
//  UserDefaultManager.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/16/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class UserDefaultManager: NSObject {

    class func getCurrentUserObject() -> User?
    {
        if let loginRespData = UserDefaults.standard.data(forKey: UserDefaultKey.loginResponse)
        {
            let decoder = JSONDecoder()
            if let loginResp = try? decoder.decode(LoginResponse.self, from: loginRespData)
            {
                return loginResp.user
            }
        }
        return nil
    }
    class func getCurrentUserId() -> Int?
    {
        if let loginRespData = UserDefaults.standard.data(forKey: UserDefaultKey.loginResponse)
        {
            let decoder = JSONDecoder()
            if let loginResp = try? decoder.decode(LoginResponse.self, from: loginRespData)
            {
                return loginResp.user?.userId
            }
        }
        return nil
    }
    class func getAccessToken() -> String?
    {
        if let loginRespData = UserDefaults.standard.data(forKey: UserDefaultKey.loginResponse)
        {
            let decoder = JSONDecoder()
            if let loginResp = try? decoder.decode(LoginResponse.self, from: loginRespData)
            {
                return loginResp.access
            }
        }
        return nil
    }
    class func getRefreshToken() -> String?
    {
        if let loginRespData = UserDefaults.standard.data(forKey: UserDefaultKey.loginResponse)
        {
            let decoder = JSONDecoder()
            if let loginResp = try? decoder.decode(LoginResponse.self, from: loginRespData)
            {
                return loginResp.refresh
            }
        }
        return nil
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
