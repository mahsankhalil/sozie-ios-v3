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
    struct Singleton {
        static let sharedInstance = ServerManager()
    }
    
    class var sharedInstance: ServerManager {
        return Singleton.sharedInstance
    }
    
    public typealias CompletionHandler = ((Bool,Any)->Void)?
    
    func loginWith(params : [String : Any] , block : CompletionHandler)
    {
//        Alamofire.request(Constant.loginURL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil) { (response : DataResponse<Any>) in
        
//        Alamofire.request(Constant.loginURL, method: .post , parameters: params, encoding:URLEncoding.default , headers: nil)
        
        Alamofire.request(Constant.loginURL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).response { response in
            
            debugPrint(response)
        }
    }
    
    func getUserProfile(params : [String : Any] , block : CompletionHandler)
    {
        
        Alamofire.request(Constant.profileURL, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).response { response in
            
            debugPrint(response)
        }
    }

}
