//
//  JSONDecoder+DecodeResponse.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/8/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
extension JSONDecoder {
    func decodeResponse<T: Decodable>(from response: DataResponse<Data>) -> Result<T> {
        guard response.error == nil else {
            print(response.error!)
            return .failure(response.error!)
        }

        guard let responseData = response.data else {
            print("didn't get any data from API")
//            return .failure(BackendError.objectSerialization(reason:
//                "Did not get data in response"))
            return .failure(CustomError(str: "Did not get data in response"))
        }
        if response.response?.statusCode == 401 {
            if UserDefaultManager.isUserLoggedIn() {
                self.logout()
                UserDefaultManager.deleteLoginResponse()
            }
            return .failure(CustomError(str: "Token has been expired"))
        }
        if !((response.response?.statusCode == 200) || (response.response?.statusCode == 201)) {
            do {
                if let data = response.data,
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    let error = getServerErrorFrom(json: json)
                    return .failure(error)
                }
            } catch {
                print("Error deserializing JSON: \(error)")
                return .failure(error)
            }
        }

        do {
            let item = try decode(T.self, from: responseData)
            return .success(item)
        } catch {
            print("error trying to decode response")
            print(error)
            return .failure(error)
        }
    }

    func getServerErrorFrom(json: [String: Any]) -> Error {
        if let nonFieldsError = json["non_field_errors"] as? [String] {
            return CustomError(str: nonFieldsError[0])
//            return BackendError.objectSerialization(reason: nonFieldsError[0])
        } else if let errors = json["errors"] as? [String: Any] {
            for key in errors.keys {
                if let keyErrors = errors[key] as? [String] {
                    return CustomError(str: keyErrors[0])
//                    return BackendError.objectSerialization(reason: keyErrors[0])
                } else {
                    return CustomError(str: "Something Went Wrong")
//                    return BackendError.objectSerialization(reason: "Something Went Wrong")
                }
            }
        } else if let detail = json["detail"] as? String {
            return CustomError(str: detail)
        }
        return CustomError(str: "Something Went Wrong")
//        return BackendError.objectSerialization(reason: "Something Went Wrong")
    }
    func logout() {
        SVProgressHUD.show()
        var dataDict = [String: Any]()
        dataDict["refresh"] =  UserDefaultManager.getRefreshToken()
        ServerManager.sharedInstance.logoutUser(params: dataDict) { (_, _) in
            SVProgressHUD.dismiss()
            UtilityManager.changeRootVCToLoginNC()
        }
    }
}
