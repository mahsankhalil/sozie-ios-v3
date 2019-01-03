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

    static let serverURL = "http://172.16.12.58:8000/api/v1/"
    static let loginURL = ServerManager.serverURL + "user/login/"
    static let profileURL = ServerManager.serverURL + "user/profile/"
    
    public typealias CompletionHandler = ((Bool,Any)->Void)?
    
    func loginWith(params : [String : Any] , block : CompletionHandler)
    {
//        Alamofire.request(Constant.loginURL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil) { (response : DataResponse<Any>) in
        
//        Alamofire.request(Constant.loginURL, method: .post , parameters: params, encoding:URLEncoding.default , headers: nil)
        
        Alamofire.request(ServerManager.loginURL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).response { response in
            
            debugPrint(response)
        }
    }
    
    func getUserProfile(params : [String : Any] , block : CompletionHandler)
    {
        
        Alamofire.request(ServerManager.profileURL, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).response { response in
            
            debugPrint(response)
        }
    }

}
