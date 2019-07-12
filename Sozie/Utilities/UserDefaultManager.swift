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
    static func checkIfMeasurementEmpty() -> Bool {
        if let user = UserDefaultManager.getCurrentUserObject() {
            if let measurements = user.measurement {
                if let size = measurements.size {
                    if size == "" {
                        return true
                    } else {
                        return false
                    }
                } else {
                    return true
                }
            } else {
                return true
            }
        } else {
            return true
        }
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

    static func getCurrentUserType() -> String? {
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
        if UserDefaults.standard.bool(forKey: UserDefaultKey.userGuide) == true {
            return true
        } else {
            return false
        }
    }
    static func isUserLoggedIn() -> Bool {
        if UserDefaultManager.getCurrentUserObject() != nil {
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
    static func getALlBrands() -> [Brand]? {
        return brandList()
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
    static func getIfUserGuideShownFor(userGuide: String) -> Bool {
        if UserDefaults.standard.bool(forKey: userGuide) == true {
            return true
        } else {
            return false
        }
    }
    static func setUserGuideShown(userGuide: String) {
        UserDefaults.standard.set(true, forKey: userGuide)
        UserDefaults.standard.synchronize()
        UserDefaultManager.checkIfALLUserGuidesShownThenDisableUserGuide()
    }
    static func setBrowserTutorialShown() {
        UserDefaults.standard.set(true, forKey: "BrowseTutorialShown")
        UserDefaults.standard.synchronize()
    }
    static func getIfBrowseTutorialShown() -> Bool {
        return UserDefaults.standard.bool(forKey: "BrowseTutorialShown")
    }
    static func setRequestTutorialShown() {
        UserDefaults.standard.set(true, forKey: "RequestTutorialShown")
        UserDefaults.standard.synchronize()
    }
    static func getIfRequestTutorialShown() -> Bool {
        return UserDefaults.standard.bool(forKey: "RequestTutorialShown")
    }
    static func checkIfALLUserGuidesShownThenDisableUserGuide() {
        if UserDefaults.standard.bool(forKey: UserDefaultKey.measurementUserGuide) == true && UserDefaults.standard.bool(forKey: UserDefaultKey.browseUserGuide) == true && UserDefaults.standard.bool(forKey: UserDefaultKey.requestSozieButtonUserGuide) == true && UserDefaults.standard.bool(forKey: UserDefaultKey.followButtonUserGuide) == true && UserDefaults.standard.bool(forKey: UserDefaultKey.mySoziesUserGuide) == true && UserDefaults.standard.bool(forKey: UserDefaultKey.myRequestsUserGuide) == true {
            makeUserGuideDisabled()
        }

    }
    static func removeAllUserGuidesShown() {
        UserDefaults.standard.set(false, forKey: UserDefaultKey.measurementUserGuide)
        UserDefaults.standard.set(false, forKey: UserDefaultKey.browseUserGuide)
        UserDefaults.standard.set(false, forKey: UserDefaultKey.requestSozieButtonUserGuide)
        UserDefaults.standard.set(false, forKey: UserDefaultKey.followButtonUserGuide)
        UserDefaults.standard.set(false, forKey: UserDefaultKey.mySoziesUserGuide)
        UserDefaults.standard.set(false, forKey: UserDefaultKey.myRequestsUserGuide)
        UserDefaults.standard.synchronize()
    }
    static func markAllUserGuidesNotShown() {
        UserDefaults.standard.set(true, forKey: UserDefaultKey.measurementUserGuide)
        UserDefaults.standard.set(true, forKey: UserDefaultKey.browseUserGuide)
        UserDefaults.standard.set(true, forKey: UserDefaultKey.requestSozieButtonUserGuide)
        UserDefaults.standard.set(true, forKey: UserDefaultKey.followButtonUserGuide)
        UserDefaults.standard.set(true, forKey: UserDefaultKey.mySoziesUserGuide)
        UserDefaults.standard.set(true, forKey: UserDefaultKey.myRequestsUserGuide)
        UserDefaults.standard.synchronize()
    }

}
