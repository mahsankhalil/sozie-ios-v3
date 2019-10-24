//
//  DoubleTextFieldCellViewModeling.swift
//  Sozie
//
//  Created by Omair Baskanderi on 2019-01-24.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import Foundation

protocol DoubleTextFieldCellViewModeling {
    var title1: String { get }
    var title2: String { get }
    var text1: String? {get}
    var text2: String? {get}
    var columnUnit: [String] { get }
    var columnPlaceholder: [String] { get }
    var columnValueSuffix: [String] { get }
    var columnValues: [[String]] { get }
    var textFieldDelegate: TextFieldDelegate? { get }
}
