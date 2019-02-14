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

    static let serverURL = "http://35.177.203.47/api/v1/"
    static let loginURL = ServerManager.serverURL + "user/login/"
    static let profileURL = ServerManager.serverURL + "user/profile/"
    static let sizeChartURL = ServerManager.serverURL + "common/sizechart"
    static let brandListURL = ServerManager.serverURL + "brand/list"
    static let countriesListURL = ServerManager.serverURL + "common/countries"
    static let validateURL = ServerManager.serverURL + "user/validate/"
    static let signUpURL = ServerManager.serverURL + "user/signup/"
    static let forgotPasswordURL = ServerManager.serverURL + "user/forgot_password/"
    static let resetPassword = ServerManager.serverURL + "user/reset_password/"
    static let productListURL = ServerManager.serverURL + "product/browse/feed/get/"
    static let logoutURL = ServerManager.serverURL + "user/logout/"
    static let categoriesURL = ServerManager.serverURL + "common/categories"
    public typealias CompletionHandler = ((Bool,Any)->Void)?
    
    func loginWith(params: [String: Any], block: CompletionHandler) {
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
    
    func getUserProfile(params: [String: Any], block : CompletionHandler) {
        Alamofire.request(ServerManager.profileURL, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).response { response in
            debugPrint(response)
        }
    }
    
    func getSizeCharts(params: [String: Any], block: CompletionHandler) {
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
    
    func getBrandList(params: [String: Any], block : CompletionHandler) {
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
    
    func getCountriesList(params: [String: Any], block: CompletionHandler) {
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
    
    func validateEmailOrUsername(params: [String: Any], block: CompletionHandler) {
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
    
    func signUpUserWith(params : [String : Any] , block : CompletionHandler) {
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
    
    func updateProfile(params : [String : Any]? , imageData : Data? , block : CompletionHandler) {
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
    
    func forgotPasswordWith(params : [String : Any] , block : CompletionHandler)
    {
        Alamofire.request(ServerManager.forgotPasswordURL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { response in
            
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
    func resetPasswordWith(params : [String : Any] , block : CompletionHandler)
    {
        Alamofire.request(ServerManager.resetPassword, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { response in
            
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
    func getAllProducts(params : [String : Any] , block : CompletionHandler)
    {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + (UserDefaultManager.getAccessToken() ?? "") 
        ]
        var url = ServerManager.productListURL
        
        if let isFirstPage = params["is_first_page"] as? Bool {
            url = url + "?is_first_page=" + String(isFirstPage ? 1:0)
        }
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseData { response in
            
            let decoder = JSONDecoder()
            let obj: Result<[Product]> = decoder.decodeResponse(from: response)
            obj.ifSuccess {
                block!(true , obj.value!)
            }
            obj.ifFailure {
                block!(false , obj.error!)
            }
            
        }
    }
    func getAllCategories(params: [String : Any], block : CompletionHandler)
    {
        Alamofire.request(ServerManager.categoriesURL, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { response in
            
            let decoder = JSONDecoder()
            let obj: Result<[Category]> = decoder.decodeResponse(from: response)
            obj.ifSuccess {
                block!(true , obj.value!)
            }
            obj.ifFailure {
                block!(false , obj.error!)
            }
            
        }
    }
    
    func logoutUser(params : [String : Any], block : CompletionHandler)
    {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + (UserDefaultManager.getAccessToken() ?? "")
        ]
        Alamofire.request(ServerManager.logoutURL, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseData { response in
            
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


    
}
