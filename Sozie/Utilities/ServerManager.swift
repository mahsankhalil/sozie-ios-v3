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

}
