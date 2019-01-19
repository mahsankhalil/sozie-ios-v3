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
        for elem in self
        {
            arrayOfString.append(String(describing: elem))
        }
        return arrayOfString
    }
}
