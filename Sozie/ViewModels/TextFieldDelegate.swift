//
//  TextFieldDelegate.swift
//  Sozie
//
//  Created by Omair Baskanderi on 2019-01-25.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import Foundation

protocol TextFieldDelegate {
    func textFieldDidUpdate(_ sender: Any?, text: String)
    func textFieldDidUpdate(_ sender: Any?, textField1: String, textField2: String)
}
