//
//  SegmentManager.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 8/6/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import Analytics
class SegmentManager: NSObject {

    class func createEntity(user: User) {
        var dataDict = [String: Any]()
        dataDict["email"] = user.email
        dataDict["firstname"] = user.firstName
        dataDict["lastname"] = user.lastName
        dataDict["gender"] = user.gender
        if let firstName = user.firstName, let lastName = user.lastName {
            dataDict["name"] = firstName + " " + lastName
        }
        if let height = user.measurement?.height {
            var heightMeasurment = NSMeasurement(doubleValue: Double(height), unit: UnitLength.inches)
            if user.measurement?.unit?.lowercased() == "cm" {
                heightMeasurment = NSMeasurement(doubleValue: Double(height), unit: UnitLength.centimeters)
            }
            let feetMeasurement = heightMeasurment.converting(to: UnitLength.feet)
            let heightText = feetMeasurement.value.feetToFeetInches()
            dataDict["height"] = heightText
        }
        dataDict["waist_measurement"] = user.measurement?.waist
        dataDict["hip_measurement"] = user.measurement?.hip
        if let bra = user.measurement?.bra, let cup = user.measurement?.cup {
            dataDict["bra_size"] = String(bra) + cup
        }
        dataDict["dress_size"] = user.measurement?.size
        let birthday = UtilityManager.dateFromStringWithFormat(date: user.birthday, format: "yyyy-MM-dd")
        let timeInterval = birthday.timeIntervalSince1970
        dataDict["date_of_birth"] = Int64(timeInterval * 1000)
        let betaTester = Bundle.main.infoDictionary?["BETA_TESTER"] as! String
        var betaTesterBool = false
        if betaTester == "YES" {
            betaTesterBool = true
        }
        dataDict["created_at"] = user.createdAt
        dataDict["beta_testing"] = betaTesterBool
        var signUpComplete = false
        if UserDefaultManager.checkIfMeasurementEmpty() {
            signUpComplete = true
        }
        dataDict["sign-up_complete"] = signUpComplete
        let analytics = (UIApplication.shared.delegate as! AppDelegate).segmentAnalytics
        analytics?.identify(String(user.userId), traits: dataDict)
    }
    class func createEventSignUpCompleted() {
        let analytics = (UIApplication.shared.delegate as! AppDelegate).segmentAnalytics
        if let user = UserDefaultManager.getCurrentUserObject() {
            analytics?.track("SignUp-Completed", properties: ["userId": user.userId])
        }
    }

    class func createEventTutorialCompleted() {
        let analytics = (UIApplication.shared.delegate as! AppDelegate).segmentAnalytics
        if let user = UserDefaultManager.getCurrentUserObject() {
            analytics?.track("Tutorial-Completed", properties: ["userId": user.userId])
        }
    }
    class func createEventRequestSubmitted() {
        let analytics = (UIApplication.shared.delegate as! AppDelegate).segmentAnalytics
        if let user = UserDefaultManager.getCurrentUserObject() {
            analytics?.track("Request-Submitted", properties: ["userId": user.userId])
        }
    }
    class func createEventSecondScreenSignupCompleted() {
        let analytics = (UIApplication.shared.delegate as! AppDelegate).segmentAnalytics
        if let user = UserDefaultManager.getCurrentUserObject() {
            analytics?.track("Second-Screen-of-Sign-Up-Completed", properties: ["userId": user.userId])
        }
    }
    class func createEventDownloaded() {
        let analytics = (UIApplication.shared.delegate as! AppDelegate).segmentAnalytics
        analytics?.track("App-Downloaded")
    }
}
