//
//  UserDefaultManager.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/16/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class UserDefaultManager: NSObject {

    private static func loginResponse() -> LoginResponse? {
        if let loginResponseData = UserDefaults.standard.data(forKey: UserDefaultKey.loginResponse) {
            let decoder = JSONDecoder()
            if let loginResponse = try? decoder.decode(LoginResponse.self, from: loginResponseData) {
                return loginResponse
            }
        }
        return nil
    }
    
    static func getCurrentUserObject() -> User? {
        guard let loginResponse = loginResponse() else { return nil }
        return loginResponse.user
    }
    
    static func getCurrentUserId() -> Int? {
        guard let loginResponse = loginResponse() else { return nil }
        return loginResponse.user?.userId
    }
    
    static func getAccessToken() -> String? {
        guard let loginResponse = loginResponse() else { return nil }
        return loginResponse.access
    }
    
    static func getRefreshToken() -> String? {
        guard let loginResponse = loginResponse() else { return nil }
        return loginResponse.refresh
    }
    
    static func saveLoginResponse(loginResp : LoginResponse) -> Bool {
        let encoder = JSONEncoder()
        if let loginResp = try? encoder.encode(loginResp) {
            UserDefaults.standard.set(loginResp, forKey: UserDefaultKey.loginResponse)
            UserDefaults.standard.synchronize()
            return true
        }
        
        return false
    }

}
