//
//  AdidasAPIManager.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/20/20.
//  Copyright © 2020 Danial Zahid. All rights reserved.
//

import UIKit
import Alamofire

class AdidasAPIManager: NSObject {
    static let sharedInstance = AdidasAPIManager()
    static let serverURL = "https://www.adidas.co.uk/"
    static let nearbyStores = AdidasAPIManager.serverURL + "api/inventory-check"
    public typealias CompletionHandler = ((Bool, Any) -> Void)?
    func getNearbyStores(params: [String: Any], block: CompletionHandler) {
        let url = AdidasAPIManager.nearbyStores
        //        url = url.appendParameters(params: params)
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { response in
            let decoder = JSONDecoder()
            let obj: Result<AdidasProductResponse> = decoder.decodeResponse(from: response)
            obj.ifSuccess {
                block!(true, obj.value!)
            }
            obj.ifFailure {
                block!(false, obj.error!)
            }
        }
    }
}
