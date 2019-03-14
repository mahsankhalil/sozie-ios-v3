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
    
    static func updateUserObject(user: User) {
        guard var loginResponse = loginResponse() else { return  }
        loginResponse.user = user
        _ = UserDefaultManager.saveLoginResponse(loginResp: loginResponse)
    }
    static func getCurrentUserId() -> Int? {
        guard let loginResponse = loginResponse() else { return nil }
        return loginResponse.user?.userId
    }
    
    static func getCurrentUserType() -> String?
    {
        guard let loginResponse = loginResponse() else { return nil }
        return loginResponse.user?.type
    }
    
    static func deleteLoginResponse() {
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.loginResponse)
        UserDefaults.standard.synchronize()
    }
    
    static func getAccessToken() -> String? {
        guard let loginResponse = loginResponse() else { return nil }
        return loginResponse.access
    }
    
    static func getRefreshToken() -> String? {
        guard let loginResponse = loginResponse() else { return nil }
        return loginResponse.refresh
    }
    static func isUserGuideDisabled() -> Bool {
        if (UserDefaults.standard.bool(forKey: UserDefaultKey.userGuide) as? Bool) == true {
            return true
        } else {
            return false
        }
    }
    static func makeUserGuideDisabled() {
        UserDefaults.standard.set(true, forKey: UserDefaultKey.userGuide)
        UserDefaults.standard.synchronize()
    }
    static func makeUserGuideEnable() {
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.userGuide)
        UserDefaults.standard.synchronize()
    }

    static func saveLoginResponse(loginResp: LoginResponse) -> Bool {
        let encoder = JSONEncoder()
        if let loginResp = try? encoder.encode(loginResp) {
            UserDefaults.standard.set(loginResp, forKey: UserDefaultKey.loginResponse)
            UserDefaults.standard.synchronize()
            return true
        }
        return false
    }
    static func saveAllBrands(brands: [Brand]) -> Bool {
        let encoder = JSONEncoder()
        if let brandsList = try? encoder.encode(brands) {
            UserDefaults.standard.set(brandsList, forKey: UserDefaultKey.brands)
            UserDefaults.standard.synchronize()
        }
        return false
    }

    private static func brandList () -> [Brand]? {
        if let brandList = UserDefaults.standard.data(forKey: UserDefaultKey.brands) {
            let decoder = JSONDecoder()
            if let brands = try? decoder.decode([Brand].self, from: brandList) {
                return brands
            }
        }
        return nil
    }
    static func getBrandWithId(brandId: Int) -> Brand? {
        guard let brands = brandList() else { return nil }
        if let brand = brands.first(where: {$0.brandId == brandId}) {
            return brand
        } else {
            return nil
        }
    }
    static func getIfShopper() -> Bool {
        if let userType = UserDefaultManager.getCurrentUserType() {
            if userType == UserType.shopper.rawValue {
                return true
            } else {
                return false
            }
        }
        return true
    }

}
