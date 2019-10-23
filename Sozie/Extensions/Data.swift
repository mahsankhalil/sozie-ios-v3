//
//  Data.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 7/8/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
