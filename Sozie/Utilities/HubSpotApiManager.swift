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
    static let contactURL = HubSpotApiManager.serverURL + "contacts/v1/contact/?hapikey=aa58ddcb-1570-41d4-8918-d5f52f0c8c56"
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

//        var typeProperty = [String: Any]()
//        typeProperty["property"] = "type"
//        typeProperty["value"] = "Sozie"
//        properties.append(typeProperty)
        var dataDict = [String: Any]()
        dataDict["properties"] = properties//.toJSONString()
        HubSpotApiManager.sharedInstance.createContact(params: dataDict) { (_, _) in
        }
    }
}
