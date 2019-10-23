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
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }

    public func getActualSizeImageURL() -> String? {
        var urlComponents = URLComponents(string: self)
        if var queryitems = urlComponents?.queryItems {
            for item in queryitems {
                if item.name == "w" || item.name == "h" || item.name == "bg" || item.name == "trim" {
                    queryitems.removeAll { $0 == item}
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

    public mutating func appendParameters(params: [String: Any]) -> String {
        var currentString = self
        currentString = currentString + "?"
        for key in params.keys {
            if let strValue = params[key] as? String {
                currentString = currentString + key + "=" + strValue
                currentString = currentString + "&"
            }
            if let intValue = params[key] as? Int {
                currentString = currentString + key + "=" + String(intValue)
                currentString = currentString + "&"
            }
            if let boolValue = params[key] as? Bool {
                currentString = currentString + key + "=" + String(boolValue)
                currentString = currentString + "&"
            }
        }
        currentString.removeLast()
        return currentString
    }
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    func getColonSeparatedErrorDetails() -> [String: Any]? {
        var strArray = self.components(separatedBy: "-:-")
        if strArray.count == 2 {
            return ["title": strArray[0], "description": strArray[1]]
        } else {
            return nil
        }
    }
}
