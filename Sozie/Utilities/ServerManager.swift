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
//    static let serverURL = "http://172.16.12.58:8000/api/v1/"
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
    static let productDetailURL = ServerManager.serverURL + "product/detail/"
    static let productCountURL = ServerManager.serverURL + "product/browse/feed/count/"
    static let favProductURL = ServerManager.serverURL + "product/favourite/"
    static let reportURL = ServerManager.serverURL + "post/report/"
    static let followURL = ServerManager.serverURL + "user/follow/"
    static let blockURL = ServerManager.serverURL + "user/block/"
    static let requestURL = ServerManager.serverURL + "productrequest/request/"
    public typealias CompletionHandler = ((Bool, Any) -> Void)?
    func loginWith(params: [String: Any], block: CompletionHandler) {
        Alamofire.request(ServerManager.loginURL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { response in
            guard let block = block else { return }
            let decoder = JSONDecoder()
            let obj: Result<LoginResponse> = decoder.decodeResponse(from: response)
            obj.ifSuccess {
                block(true, obj.value!)
            }
            obj.ifFailure {
                block(false, obj.error!)
            }
        }
    }

    func getUserProfile(params: [String: Any], block: CompletionHandler) {
        Alamofire.request(ServerManager.profileURL, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).response { response in
            debugPrint(response)
        }
    }

    func getSizeCharts(params: [String: Any], block: CompletionHandler) {
        Alamofire.request(ServerManager.sizeChartURL, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { response in
            guard let block = block else { return }
            let decoder = JSONDecoder()
            let obj: Result<Size> = decoder.decodeResponse(from: response)
            obj.ifSuccess {
                block(true, obj.value!)
            }
            obj.ifFailure {
                block(false, obj.error!)
            }
        }
    }

    func getBrandList(params: [String: Any], block: CompletionHandler) {
        Alamofire.request(ServerManager.brandListURL, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { response in
            guard let block = block else { return }
            let decoder = JSONDecoder()
            let obj: Result<[Brand]> = decoder.decodeResponse(from: response)
            obj.ifSuccess {
                block(true, obj.value!)
            }
            obj.ifFailure {
                block(false, obj.error!)
            }
        }
    }

    func getCountriesList(params: [String: Any], block: CompletionHandler) {
        Alamofire.request(ServerManager.countriesListURL, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { response in
            guard let block = block else { return }
            let decoder = JSONDecoder()
            let obj: Result<[Country]> = decoder.decodeResponse(from: response)
            obj.ifSuccess {
                block(true, obj.value!)
            }
            obj.ifFailure {
                block(false, obj.error!)
            }
        }
    }

    func validateEmailOrUsername(params: [String: Any], block: CompletionHandler) {
        Alamofire.request(ServerManager.validateURL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { response in
            guard let block = block else { return }
            let decoder = JSONDecoder()
            let obj: Result<ValidateRespose> = decoder.decodeResponse(from: response)
            obj.ifSuccess {
                block(true, obj.value!)
            }
            obj.ifFailure {
                block(false, obj.error!)
            }
        }
    }

    func signUpUserWith(params: [String: Any], block: CompletionHandler) {
        Alamofire.request(ServerManager.signUpURL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { response in
            guard let block = block else { return }
            let decoder = JSONDecoder()
            let obj: Result<LoginResponse> = decoder.decodeResponse(from: response)
            obj.ifSuccess {
                block(true, obj.value!)
            }
            obj.ifFailure {
                block(false, obj.error!)
            }
        }
    }

    func updateProfile(params: [String: Any]?, imageData: Data?, block: CompletionHandler) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + (UserDefaultManager.getAccessToken() ?? "") ,
            "Content-type": "multipart/form-data"
        ]

        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in (params ?? [:]) {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }

            if let data = imageData {
                multipartFormData.append(data, withName: "picture", fileName: "image.png", mimeType: "image/png")
            }
        }, usingThreshold: UInt64.init(), to: ServerManager.profileURL + String(UserDefaultManager.getCurrentUserId()!) + "/", method: .patch, headers: headers) { (result) in

            switch result {
            case .success(let upload, _, _):
                upload.responseData { response in
                    let decoder = JSONDecoder()
                    let obj: Result<User> = decoder.decodeResponse(from: response)
                    obj.ifSuccess {
                        block!(true, obj.value!)
                    }
                    obj.ifFailure {
                        block!(false, obj.error!)
                    }

                }
            case .failure(let error):
                block!(false, error)
            }
        }
    }

    func forgotPasswordWith(params: [String: Any], block: CompletionHandler) {

        Alamofire.request(ServerManager.forgotPasswordURL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { response in
            let decoder = JSONDecoder()
            let obj: Result<ValidateRespose> = decoder.decodeResponse(from: response)
            obj.ifSuccess {
                block!(true, obj.value!)
            }
            obj.ifFailure {
                block!(false, obj.error!)
            }
        }
    }

    func resetPasswordWith(params: [String: Any], block: CompletionHandler) {

        Alamofire.request(ServerManager.resetPassword, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { response in
            let decoder = JSONDecoder()
            let obj: Result<ValidateRespose> = decoder.decodeResponse(from: response)
            obj.ifSuccess {
                block!(true, obj.value!)
            }
            obj.ifFailure {
                block!(false, obj.error!)
            }
        }
    }

    func getAllProducts(params: [String: Any], block: CompletionHandler) {
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
                block!(true, obj.value!)
            }
            obj.ifFailure {
                block!(false, obj.error!)
            }
        }
    }

    func getProductsCount(params: [String: Any], block: CompletionHandler) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + (UserDefaultManager.getAccessToken() ?? "")
        ]
        Alamofire.request(ServerManager.productCountURL, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseData { response in

            let decoder = JSONDecoder()
            let obj: Result<CountResponse> = decoder.decodeResponse(from: response)
            obj.ifSuccess {
                block!(true, obj.value!)
            }
            obj.ifFailure {
                block!(false, obj.error!)
            }

        }
    }
    func getProductDetail(productId: String, block: CompletionHandler) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + (UserDefaultManager.getAccessToken() ?? "")
        ]
        let url = ServerManager.productDetailURL + String(productId) + "/"
        Alamofire.request(url, method: .get, parameters: [:], encoding: URLEncoding.default, headers: headers).responseData { response in

            let decoder = JSONDecoder()
            let obj: Result<Product> = decoder.decodeResponse(from: response)
            obj.ifSuccess {
                block!(true, obj.value!)
            }
            obj.ifFailure {
                block!(false, obj.error!)
            }

        }
    }

    func favouriteProduct(params: [String: Any], block: CompletionHandler) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + (UserDefaultManager.getAccessToken() ?? "")
        ]
        Alamofire.request(ServerManager.favProductURL, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseData { response in

            let decoder = JSONDecoder()
            let obj: Result<ValidateRespose> = decoder.decodeResponse(from: response)
            obj.ifSuccess {
                block!(true, obj.value!)
            }
            obj.ifFailure {
                block!(false, obj.error!)
            }

        }
    }

    func removeFavouriteProduct(productId: String, block: CompletionHandler) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + (UserDefaultManager.getAccessToken() ?? "")
        ]
        let url = ServerManager.favProductURL + productId + "/"
        Alamofire.request(url, method: .delete, parameters: [:], encoding: URLEncoding.default, headers: headers).responseData { response in

            let decoder = JSONDecoder()
            let obj: Result<ValidateRespose> = decoder.decodeResponse(from: response)
            obj.ifSuccess {
                block!(true, obj.value!)
            }
            obj.ifFailure {
                block!(false, obj.error!)
            }

        }
    }

    func getFavouriteList(params: [String: Any], block: CompletionHandler) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + (UserDefaultManager.getAccessToken() ?? "")
        ]
        Alamofire.request(ServerManager.favProductURL, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).responseData { response in

            let decoder = JSONDecoder()
            let obj: Result<[Product]> = decoder.decodeResponse(from: response)
            obj.ifSuccess {
                block!(true, obj.value!)
            }
            obj.ifFailure {
                block!(false, obj.error!)
            }
        }
    }
    func getAllCategories(params: [String: Any], block: CompletionHandler) {
        Alamofire.request(ServerManager.categoriesURL, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { response in

            let decoder = JSONDecoder()
            let obj: Result<[Category]> = decoder.decodeResponse(from: response)
            obj.ifSuccess {
                block!(true, obj.value!)
            }
            obj.ifFailure {
                block!(false, obj.error!)
            }

        }
    }

    func logoutUser(params: [String: Any], block: CompletionHandler) {

        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + (UserDefaultManager.getAccessToken() ?? "")
        ]
        Alamofire.request(ServerManager.productCountURL, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseData { response in
            let decoder = JSONDecoder()
            let obj: Result<CountResponse> = decoder.decodeResponse(from: response)
            obj.ifSuccess {
                block!(true, obj.value!)
            }
            obj.ifFailure {
                block!(false, obj.error!)
            }
        }
    }
    func followUser(params: [String: Any], block: CompletionHandler) {

        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + (UserDefaultManager.getAccessToken() ?? "")
        ]
        Alamofire.request(ServerManager.followURL, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseData { response in
            let decoder = JSONDecoder()
            let obj: Result<ValidateRespose> = decoder.decodeResponse(from: response)
            obj.ifSuccess {
                block!(true, obj.value!)
            }
            obj.ifFailure {
                block!(false, obj.error!)
            }
        }
    }
    func blockUser(params: [String: Any], block: CompletionHandler) {

        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + (UserDefaultManager.getAccessToken() ?? "")
        ]
        Alamofire.request(ServerManager.blockURL, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseData { response in
            let decoder = JSONDecoder()
            let obj: Result<ValidateRespose> = decoder.decodeResponse(from: response)
            obj.ifSuccess {
                block!(true, obj.value!)
            }
            obj.ifFailure {
                block!(false, obj.error!)
            }
        }
    }
    func reportPost(params: [String: Any], block: CompletionHandler) {

        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + (UserDefaultManager.getAccessToken() ?? "")
        ]
        Alamofire.request(ServerManager.reportURL, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseData { response in
            let decoder = JSONDecoder()
            let obj: Result<ValidateRespose> = decoder.decodeResponse(from: response)
            obj.ifSuccess {
                block!(true, obj.value!)
            }
            obj.ifFailure {
                block!(false, obj.error!)
            }
        }
    }
    func makePostRequest(params: [String: Any], block: CompletionHandler) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + (UserDefaultManager.getAccessToken() ?? "")
        ]
        Alamofire.request(ServerManager.requestURL, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseData { response in
            let decoder = JSONDecoder()
            let obj: Result<ValidateRespose> = decoder.decodeResponse(from: response)
            obj.ifSuccess {
                block!(true, obj.value!)
            }
            obj.ifFailure {
                block!(false, obj.error!)
            }
        }
    }
}
