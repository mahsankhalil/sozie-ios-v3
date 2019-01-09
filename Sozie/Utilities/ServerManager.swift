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
    
    func getSizeCharts(params : [String : Any] , block : CompletionHandler)
    {


        Alamofire.request(ServerManager.sizeChartURL, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { response in
            
            let decoder = JSONDecoder()
            let obj: Result<SizeChart> = decoder.decodeResponse(from: response)
            obj.ifSuccess {
                block!(true , obj.value!)
            }
            obj.ifFailure {
                block!(false , obj.error!)
            }
            


        }
    }

}
