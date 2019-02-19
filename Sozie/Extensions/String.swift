//
//  String.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/28/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

extension String {
    
    public func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    public func getActualSizeImageURL() -> String? {
        var urlComponents = URLComponents(string: self)
        if var queryitems = urlComponents?.queryItems {
            for item in queryitems {
                if item.name == "w" || item.name == "h" || item.name == "bg" || item.name == "trim" {
                    queryitems.removeAll{$0 == item}
                }
            }
            urlComponents?.queryItems = queryitems
            return urlComponents?.string
        } else {
            return urlComponents?.string
        }
    }
    
    public func getCurrencySymbol() -> String {
        switch self {
        case "GBP":
            return "£"
        case "USD":
            return "$"
        case "EUR":
            return "€"
        default:
            return ""
        }
    }

}
