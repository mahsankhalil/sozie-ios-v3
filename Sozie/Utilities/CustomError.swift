//
//  CustomError.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/11/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class CustomError: NSObject, LocalizedError {
    var desc = ""
    init(str: String) {
        desc = str
    }
    override var description: String {
        get {
            return desc
        }
    }
    //You need to implement `errorDescription`, not `localizedDescription`.
    var errorDescription: String? {
        get {
            return self.description
        }
    }
}
