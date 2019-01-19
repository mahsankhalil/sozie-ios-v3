//
//  ServerManager.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/1/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import Alamofire

class ServerManager: NSObject {

    static let sharedInstance = ServerManager()

    static let serverURL = "http://3.8.161.238/api/v1/"
    static let loginURL = ServerManager.serverURL + "user/login/"
    static let profileURL = ServerManager.serverURL + "user/profile/"
    static let sizeChartURL = ServerManager.serverURL + "common/sizechart"
    static let brandListURL = ServerManager.serverURL + "brand/list"
    static let countriesListURL = ServerManager.serverURL + "common/countries"
    static let validateURL = ServerManager.serverURL + "user/validate/"
    static let signUpURL = ServerManager.serverURL + "user/signup/"
    public typealias CompletionHandler = ((Bool,Any)->Void)?
    
    func loginWith(params : [String : Any] , block : CompletionHandler)
    {
        
        Alamofire.request(ServerManager.loginURL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { response in
            
            let decoder = JSONDecoder()
            let obj: Result<LoginResponse> = decoder.decodeResponse(from: response)
            obj.ifSuccess {
                block!(true , obj.value!)
            }
            obj.ifFailure {
                block!(false , obj.error!)
            }
            
        }
    }
    
    func getUserProfile(params : [String : Any] , block : CompletionHandler)
    {
        
        Alamofire.request(ServerManager.profileURL, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).response { response in
            
            
            debugPrint(response)
        }
    }
    
    func getSizeCharts(params : [String : Any] , block : CompletionHandler)
    {

        Alamofire.request(ServerManager.sizeChartURL, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { response in
            
            let decoder = JSONDecoder()
            let obj: Result<Size> = decoder.decodeResponse(from: response)
            obj.ifSuccess {
                block!(true , obj.value!)
            }
            obj.ifFailure {
                block!(false , obj.error!)
            }
            
        }
    }
    func getBrandList(params : [String : Any] , block : CompletionHandler)
    {
        
        Alamofire.request(ServerManager.brandListURL, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { response in
            
            let decoder = JSONDecoder()
            let obj: Result<[Brand]> = decoder.decodeResponse(from: response)
            obj.ifSuccess {
                block!(true , obj.value!)
            }
            obj.ifFailure {
                block!(false , obj.error!)
            }
            
        }
    }
    
    func getCountriesList(params : [String : Any], block : CompletionHandler)
    {
        Alamofire.request(ServerManager.countriesListURL, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { response in
            
            let decoder = JSONDecoder()
            let obj: Result<[Country]> = decoder.decodeResponse(from: response)
            obj.ifSuccess {
                block!(true , obj.value!)
            }
            obj.ifFailure {
                block!(false , obj.error!)
            }
            
        }
    }
    
    func validateEmailOrUsername(params : [String : Any], block : CompletionHandler)
    {
        Alamofire.request(ServerManager.validateURL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { response in
            
            let decoder = JSONDecoder()
            let obj: Result<ValidateRespose> = decoder.decodeResponse(from: response)
            obj.ifSuccess {
                block!(true , obj.value!)
            }
            obj.ifFailure {
                block!(false , obj.error!)
            }
            
        }
    }
    
    func signUpUserWith(params : [String : Any] , block : CompletionHandler)
    {
        Alamofire.request(ServerManager.signUpURL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { response in
            
            let decoder = JSONDecoder()
            let obj: Result<LoginResponse> = decoder.decodeResponse(from: response)
            obj.ifSuccess {
                block!(true , obj.value!)
            }
            obj.ifFailure {
                block!(false , obj.error!)
            }
            
        }
    }
    
    func updateProfile(params : [String : Any]? , imageData : Data? , block : CompletionHandler)
    {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + (UserDefaultManager.getAccessToken() ?? "") ,
            "Content-type": "multipart/form-data"
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in (params ?? [:]) {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let data = imageData{
                multipartFormData.append(data, withName: "picture", fileName: "image.png", mimeType: "image/png")
            }
            

        }, usingThreshold: UInt64.init(), to: ServerManager.profileURL + String(UserDefaultManager.getCurrentUserId()!) + "/", method: .patch, headers: headers) { (result) in

            switch result{
            case .success(let upload, _, _):
                upload.responseData { response in
                    let decoder = JSONDecoder()
                    let obj: Result<User> = decoder.decodeResponse(from: response)
                    obj.ifSuccess {
                        block!(true , obj.value!)
                    }
                    obj.ifFailure {
                        block!(false , obj.error!)
                    }

                }
            case .failure(let error):
                block!(false , error)
            }
        }

    }

    
}
