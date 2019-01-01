//
//  WebClient.swift
//  WeatherApp
//
//  Created by Danial Zahid on 12/26/15.
//  Copyright © 2015 Danial Zahid. All rights reserved.
//

import UIKit
import AFNetworking

let RequestManager = WebClient.sharedInstance

class WebClient: AFHTTPSessionManager {
    
    //MARK: - Shared Instance
    static let sharedInstance = WebClient(url: NSURL(string: Constant.serverURL)!, securityPolicy: AFSecurityPolicy(pinningMode: AFSSLPinningMode.none))
    
    
    convenience init(url: NSURL, securityPolicy: AFSecurityPolicy){
        self.init(baseURL: url as URL)
        self.securityPolicy = securityPolicy
        
    }
    
    
    func postPath(urlString: String,
                  params: [String: AnyObject],
                  addToken: Bool = true,
                  successBlock success:@escaping (AnyObject) -> (),
                  failureBlock failure: @escaping (String) -> ()){
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        
        if let sessionID = UserDefaults.standard.value(forKey: UserDefaultKey.sessionID) as? String {
            manager.requestSerializer.setValue(sessionID, forHTTPHeaderField: UserDefaultKey.sessionID)
        }
        
        manager.post((NSURL(string: urlString, relativeTo: self.baseURL)?.absoluteString)!, parameters: params, progress: nil, success: {
            (sessionTask, responseObject) -> () in
            print(responseObject ?? "")
            success(responseObject! as AnyObject)
        },  failure: {
            (sessionTask, error) -> () in
            print(error)
            
            let err = error as NSError
            do {

                
                if let data = err.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as? Data {
                    let dictionary = try JSONSerialization.jsonObject(with: data,
                                                                      options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: AnyObject]
                    
                    if let status = dictionary["status"] as? String {
                        if status == "403" {
                            Router.logout()
                        }
                        
                    }
                    
                    failure(dictionary["message"]! as! String)
                }
                else{
                    failure("Failed to connect")
                }
            }catch
            {
                failure(error.localizedDescription)
            }
            
        })
    }
    
    func multipartPost(urlString: String,
                       params: [String: AnyObject],
                       image: UIImage?,
                       imageName: String,
                       addToken: Bool = true,
                       progressBlock progressB:@escaping (Int) -> (),
                       successBlock success:@escaping (AnyObject) -> (),
                       failureBlock failure: @escaping (NSError) -> ()){
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        
        
        if let sessionID = UserDefaults.standard.value(forKey: UserDefaultKey.sessionID) as? String {
            manager.requestSerializer.setValue(sessionID, forHTTPHeaderField: UserDefaultKey.sessionID)
        }
        
        manager.post((NSURL(string: urlString, relativeTo: self.baseURL)?.absoluteString)!, parameters: params, constructingBodyWith: { (data) in
            if image != nil {
                if let imageData = image!.pngData() {
                    data.appendPart(withFileData: imageData, name: imageName, fileName: "image", mimeType: "image/jpeg")
                }
            }
            
        }, progress: { (progress) in
            progressB(Int(progress.completedUnitCount))
        }, success: {
            (sessionTask, responseObject) -> () in
            print(responseObject ?? "")
            success(responseObject! as AnyObject)
        },  failure: {
            (sessionTask, error) -> () in
            print(error)
            failure(error as NSError)
        })
    }
    
    
    func getPath(urlString: String,
                 params: [String: AnyObject]?,
                 addToken: Bool = true,
                 successBlock success:@escaping (AnyObject) -> (),
                 failureBlock failure: @escaping (NSError) -> ()){
        
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        
        if let sessionID = UserDefaults.standard.value(forKey: UserDefaultKey.sessionID) as? String , addToken == true {
            manager.requestSerializer.setValue(sessionID, forHTTPHeaderField: UserDefaultKey.sessionID)
        }
        
        manager.get((NSURL(string: urlString, relativeTo: self.baseURL)?.absoluteString)!, parameters: params, progress: nil, success: {
            (sessionTask, responseObject) -> () in
//            print(responseObject ?? "")
            success(responseObject! as AnyObject)
        }, failure: {
            (sessionTask, error) -> () in
            print(error)
            failure(error as NSError)
            
            let err = error as NSError
            do {
                
                if let data = err.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as? Data {
                    let dictionary = try JSONSerialization.jsonObject(with: data,
                                                                      options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: AnyObject]
                    if let status = dictionary["status"] as? String {
                        if status == "403" {
                            Router.logout()
                        }
                        
                    }
                }
            }
            catch {
                
            }
        })
    }
    
    func deletePath(urlString: String,
                 params: [String: AnyObject]?,
                 addToken: Bool = true,
                 successBlock success:@escaping (AnyObject) -> (),
                 failureBlock failure: @escaping (NSError) -> ()){
        
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        
        if let sessionID = UserDefaults.standard.value(forKey: UserDefaultKey.sessionID) as? String , addToken == true {
            manager.requestSerializer.setValue(sessionID, forHTTPHeaderField: UserDefaultKey.sessionID)
        }
        
        manager.delete((NSURL(string: urlString, relativeTo: self.baseURL)?.absoluteString)!, parameters: params, success: {
            (sessionTask, responseObject) -> () in
            print(responseObject ?? "")
            success(responseObject! as AnyObject)
        }, failure: {
            (sessionTask, error) -> () in
            print(error)
            failure(error as NSError)
            
        })
    }
    
    
    
    func signUpUser(param: [String: Any], successBlock success:@escaping ([String: AnyObject]) -> (),
                    failureBlock failure:@escaping (String) -> ()){
        self.postPath(urlString: Constant.registrationURL, params: param as [String : AnyObject], successBlock: { (response) in
            print(response)
            if (response[Constant.statusKey] as AnyObject).boolValue == true{
                success(response[Constant.responseKey] as! [String : AnyObject])
            }
            else{
                if response.object(forKey: "message") as? String != "" {
                    failure(response.object(forKey: "message") as! String)
                }
                else{
                    failure("Unable to fetch data")
                }
            }
        }) { (error) in
//            if error.code == 422 {
//                failure("Email already in use")
//            }
//            else{
//                failure(error.localizedDescription)
//            }
            failure(error)
            
        }
    }
    
    func loginUser(param: [String: Any], successBlock success:@escaping ([String: AnyObject]) -> (),
                   failureBlock failure:@escaping (String) -> ()){
        self.postPath(urlString: Constant.loginURL, params: param as [String : AnyObject], successBlock: { (response) in
            print(response)
            if (response[Constant.statusKey] as AnyObject).boolValue == true{
                success(response[Constant.responseKey] as! [String : AnyObject])
            }
            else{
                
                if response.object(forKey: "message") as? String != "" {
                    failure(response.object(forKey: "message") as! String)
                }
                else{
                    failure("Invalid credentials")
                }
            }
        }) { (error) in
//            if error.code == 422 {
//                failure("Invalid credentials")
//            }
//            failure(error.localizedDescription)
            failure(error)
        }
    }
    
    func getUser(successBlock success:@escaping ([String: AnyObject]) -> (),
                 failureBlock failure:@escaping (String) -> ()){
        
        self.getPath(urlString: Constant.getProfileURL, params: [:] as [String : AnyObject], successBlock: { (response) in
            print(response)
            if (response[Constant.statusKey] as AnyObject).boolValue == true{
                success(response[Constant.responseKey] as! [String : AnyObject])
            }
            else{
                if response.object(forKey: "message") as? String != "" {
                    failure(response.object(forKey: "message") as! String)
                }
                else{
                    failure("Unable to fetch data")
                }
            }
        }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    func socialLoginUser(param: [String: Any], successBlock success:@escaping ([String: AnyObject]) -> (),
                         failureBlock failure:@escaping (String) -> ()){
        self.postPath(urlString: Constant.socialLoginURL, params: param as [String : AnyObject], successBlock: { (response) in
            print(response)
            if (response[Constant.statusKey] as AnyObject).boolValue == true{
                success(response[Constant.responseKey] as! [String : AnyObject])
            }
            else{
                if response.object(forKey: "message") as? String != "" {
                    failure(response.object(forKey: "message") as! String)
                }
                else{
                    failure("Unable to fetch data")
                }
            }
        }) { (error) in
            //            failure(error.localizedDescription)
            failure(error)
        }
    }
    
    func getUserFacebookProfile(url: String,
                                successBlock success:@escaping ([String: AnyObject]) -> (),
                                failureBlock failure:@escaping (String) -> ()) {
        self.getPath(urlString: url,
                     params: [:],addToken: false, successBlock: { (response) -> () in
                        success(response as! [String : AnyObject])
        }) { (error: NSError) -> () in
            failure(error.localizedDescription)
        }
    }
    
    func getUserFacebookProfileImage(userID: String,
                                     successBlock success:@escaping ([String: AnyObject]) -> (),
                                     failureBlock failure:@escaping (String) -> ()) {
        self.getPath(urlString: "https://graph.facebook.com/\(userID)/?fields=picture",
            params: [:],addToken: false, successBlock: { (response) -> () in
                success(response as! [String : AnyObject])
        }) { (error: NSError) -> () in
            failure(error.localizedDescription)
        }
    }
    
    
    
}
