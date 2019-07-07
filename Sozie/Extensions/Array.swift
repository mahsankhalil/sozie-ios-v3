//
//  Array.swift
//  Sozie
//
//  Created by Omair Baskanderi on 2019-01-19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import Foundation

extension Array where Element == Int {
    func convertArrayToString() -> [String] {
        var arrayOfString = [String]()
        for elem in self {
            arrayOfString.append(String(describing: elem))
        }
        return arrayOfString
    }
    func makeArrayJSON() -> String {
        var json = "["
        for elem in self {
            json = json + String(elem) + ","
        }
        json.remove(at: json.index(before: json.endIndex))
        json = json + "]"
        return json
    }
}
extension Array where Element == Float {
    func convertArrayToString() -> [String] {
        var arrayOfString = [String]()
        for elem in self {
            arrayOfString.append(String(describing: elem))
        }
        return arrayOfString
    }
    func makeArrayJSON() -> String {
        var json = "["
        for elem in self {
            json = json + String(elem) + ","
        }
        json.remove(at: json.index(before: json.endIndex))
        json = json + "]"
        return json
    }
}
extension Array where Element == String {
    func convertArrayToString() -> [String] {
        var arrayOfString = [String]()
        for elem in self {
            arrayOfString.append(elem)
        }
        return arrayOfString
    }
    func makeArrayJSON() -> String {
        var json = ""
        for elem in self {
            json = json + elem + ","
        }
        json.remove(at: json.index(before: json.endIndex))
        return json
    }
}
extension Collection where Iterator.Element == [String: Any] {
    func toJSONString(options: JSONSerialization.WritingOptions = .prettyPrinted) -> String {
        if let arr = self as? [[String: Any]],
            let dat = try? JSONSerialization.data(withJSONObject: arr, options: options),
            let str = String(data: dat, encoding: String.Encoding.utf8) {
            return str
        }
        return "[]"
    }
}
