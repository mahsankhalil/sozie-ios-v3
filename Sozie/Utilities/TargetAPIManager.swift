//
//  TargetAPIManager.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 5/29/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import Alamofire

class TargetAPIManager: NSObject {
    static let sharedInstance = TargetAPIManager()
    static let serverURL = "https://api.target.com/"
    static let nearbyStores = TargetAPIManager.serverURL + "fulfillment_aggregator/v1/fiats/"
    public typealias CompletionHandler = ((Bool, Any) -> Void)?
    func getNearbyStores(productId: String, params: [String: Any], block: CompletionHandler) {
        let url = TargetAPIManager.nearbyStores + productId
//        url = url.appendParameters(params: params)
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { response in
            let decoder = JSONDecoder()
            let obj: Result<ProductResponse> = decoder.decodeResponse(from: response)
            obj.ifSuccess {
                block!(true, obj.value!)
            }
            obj.ifFailure {
                block!(false, obj.error!)
            }
        }
    }
}
