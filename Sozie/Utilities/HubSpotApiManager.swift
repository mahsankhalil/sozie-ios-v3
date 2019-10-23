//
//  HubSpotApiManager.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 7/23/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

import Alamofire

class HubSpotApiManager: NSObject {
    static let sharedInstance = HubSpotApiManager()
    static let serverURL = "https://api.hubapi.com/"
    static let apiKey = "aa58ddcb-1570-41d4-8918-d5f52f0c8c56"
    static let contactURL = HubSpotApiManager.serverURL + "contacts/v1/contact/?hapikey=" + HubSpotApiManager.apiKey
    static let updateContactURL = HubSpotApiManager.serverURL + "contacts/v1/contact/email/"
    public typealias CompletionHandler = ((Bool, Any) -> Void)?
    func createContact(params: [String: Any], block: CompletionHandler) {
        //        url = url.appendParameters(params: params)
        Alamofire.request(HubSpotApiManager.contactURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseData { response in
            let decoder = JSONDecoder()
            let obj: Result<HubSpotResponse> = decoder.decodeResponse(from: response)
            obj.ifSuccess {
                block!(true, obj.value!)
            }
            obj.ifFailure {
                block!(false, obj.error!)
            }
        }
    }
    func updateContact(email: String, params: [String: Any], block: CompletionHandler) {
        let url = HubSpotApiManager.updateContactURL + email + "/profile?hapikey=" + HubSpotApiManager.apiKey
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseData { response in
            let decoder = JSONDecoder()
            let obj: Result<HubSpotResponse> = decoder.decodeResponse(from: response)
            obj.ifSuccess {
                block!(true, obj.value!)
            }
            obj.ifFailure {
                block!(false, obj.error!)
            }
        }
    }
}

class HubSpotManager: NSObject {
    class func createContact(user: User) {
        var properties = [[String: Any]]()
        var emailProperty = [String: Any]()
        emailProperty["property"] = "email"
        emailProperty["value"] = user.email
        properties.append(emailProperty)

        var firstNameProperty = [String: Any]()
        firstNameProperty["property"] = "firstname"
        firstNameProperty["value"] = user.firstName
        properties.append(firstNameProperty)

        var lastNameProperty = [String: Any]()
        lastNameProperty["property"] = "lastname"
        lastNameProperty["value"] = user.lastName
        properties.append(lastNameProperty)

        var typeProperty = [String: Any]()
        typeProperty["property"] = "sozie"
        typeProperty["value"] = true
        properties.append(typeProperty)
        var dataDict = [String: Any]()
        dataDict["properties"] = properties//.toJSONString()
        HubSpotApiManager.sharedInstance.createContact(params: dataDict) { (_, _) in
        }
    }
    class func updateMeasurementsIn(user: User, properties: [[String: Any]]) -> [[String: Any]] {
        var measurementProperties = properties
        if let height = user.measurement?.height {
            var heightProperty = [String: Any]()
            let heightMeasurment = NSMeasurement(doubleValue: Double(height), unit: UnitLength.inches)
            let feetMeasurement = heightMeasurment.converting(to: UnitLength.feet)
            let heightText = "Height: " + feetMeasurement.value.feetToFeetInches() + "  | "
            heightProperty["property"] = "height"
            heightProperty["value"] = heightText
            measurementProperties.append(heightProperty)
        }
        var waistProperty = [String: Any]()
        waistProperty["property"] = "waist_measurement"
        waistProperty["value"] = user.measurement?.waist
        measurementProperties.append(waistProperty)
        var hipsProperty = [String: Any]()
        hipsProperty["property"] = "hips_measurement"
        hipsProperty["value"] = user.measurement?.hip
        measurementProperties.append(hipsProperty)
        if let bra = user.measurement?.bra, let cup = user.measurement?.cup {
            var braProperty = [String: Any]()
            braProperty["property"] = "bra_size"
            braProperty["value"] = String(bra) + cup
            measurementProperties.append(braProperty)
        }
        var sizeProperty = [String: Any]()
        sizeProperty["property"] = "dress_size"
        sizeProperty["value"] = user.measurement?.size
        measurementProperties.append(sizeProperty)
        return measurementProperties
    }
    class func updateContactWith(user: User) {
        var properties = [[String: Any]]()
        var firstNameProperty = [String: Any]()
        firstNameProperty["property"] = "firstname"
        firstNameProperty["value"] = user.firstName
        properties.append(firstNameProperty)
        var lastNameProperty = [String: Any]()
        lastNameProperty["property"] = "lastname"
        lastNameProperty["value"] = user.lastName
        properties.append(lastNameProperty)
        properties = HubSpotManager.updateMeasurementsIn(user: user, properties: properties)
        let birthday = UtilityManager.dateFromStringWithFormat(date: user.birthday, format: "yyyy-MM-dd")
        let timeInterval = birthday.timeIntervalSince1970

        var dobProperty = [String: Any]()
        dobProperty["property"] = "date_of_birth"
        dobProperty["value"] = Int64(timeInterval * 1000)
        properties.append(dobProperty)
        let betaTester = Bundle.main.infoDictionary?["BETA_TESTER"] as! String
        var betaTesterBool = false
        if betaTester == "YES" {
            betaTesterBool = true
        }
        var betaTesterProperty = [String: Any]()
        betaTesterProperty["property"] = "beta_tester"
        betaTesterProperty["value"] = betaTesterBool
        properties.append(betaTesterProperty)
        var signUpComplete = false
        if UserDefaultManager.checkIfMeasurementEmpty() {
            signUpComplete = true
        }
        var signUpCompleteProperty = [String: Any]()
        signUpCompleteProperty["property"] = "sign-up_complete"
        signUpCompleteProperty["value"] = signUpComplete
        properties.append(signUpCompleteProperty)
        var typeProperty = [String: Any]()
        typeProperty["property"] = "sozie"
        typeProperty["value"] = true
        properties.append(typeProperty)
        var dataDict = [String: Any]()
        dataDict["properties"] = properties
    }
}
