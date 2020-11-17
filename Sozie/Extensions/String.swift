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
        case "£":
            return self
        case "$":
            return self
        case "€":
            return self
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
        let strArray = self.components(separatedBy: "-:-")
        if strArray.count == 2 {
            return ["title": strArray[0], "description": strArray[1]]
        } else {
            return nil
        }
    }
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    func versionCompare(_ otherVersion: String) -> ComparisonResult {
        let versionDelimiter = "."
        var versionComponents = self.components(separatedBy: versionDelimiter) // <1>
        var otherVersionComponents = otherVersion.components(separatedBy: versionDelimiter)
        let zeroDiff = versionComponents.count - otherVersionComponents.count // <2>
        if zeroDiff == 0 { // <3>
            // Same format, compare normally
            return self.compare(otherVersion, options: .numeric)
        } else {
            let zeros = Array(repeating: "0", count: abs(zeroDiff)) // <4>
            if zeroDiff > 0 {
                otherVersionComponents.append(contentsOf: zeros) // <5>
            } else {
                versionComponents.append(contentsOf: zeros)
            }
            return versionComponents.joined(separator: versionDelimiter)
                .compare(otherVersionComponents.joined(separator: versionDelimiter), options: .numeric) // <6>
        }
    }
    func sizeMap() -> String {
        let sizeMapper = [
            "0": "XXS",
            "2": "XXS",
            "4": "XS",
            "6": "XS",
            "8": "S",
            "10": "S",
            "12": "M",
            "14": "M",
            "16": "L",
            "18": "L",
            "20": "XL",
            "22": "XL",
            "24": "XXL",
            "26": "XXL",
            "L": "L",
            "M": "M",
            "S": "S",
            "1X": "1X",
            "2X": "2X",
            "3X": "3X",
            "4X": "4X",
            "XL": "XL",
            "XS": "XS",
            "2XL": "XXL",
            "2XS": "XXS",
            "3XL": "3X",
            "1 Size": "1 Size"]
        if let mappedSize = sizeMapper[self] {
            return mappedSize
        } else {
            return self
        }
    }
    func getNumericSizes() -> [String] {
        let mapper = [
            "XXS": ["0", "2", "2XS", "XXS"],
            "XS": ["4", "6", "XS"],
            "S": ["8", "10", "S"],
            "M": ["12", "14", "M"],
            "L": ["16", "18", "L"],
            "XL": ["20", "22", "XL"],
            "XXL": ["24", "26", "2XL", "XXL"]
        ]
        if let sizesArray = mapper[self] {
            return sizesArray
        } else {
            return [self]
        }
    }
}
