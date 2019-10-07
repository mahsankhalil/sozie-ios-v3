//
//  SingleTextFieldCellViewModeling.swift
//  Sozie
//
//  Created by Omair Baskanderi on 2019-01-24.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import Foundation

protocol SingleTextFieldCellViewModeling {
    var title: String { get }
    var text: String? { get }
    var placeholder: String { get }
    var values: [String] { get }
    var valueSuffix: String { get }
    var buttonTappedDelegate: ButtonTappedDelegate { get }
    var columnUnit: String { get }
    var textFieldDelegate: TextFieldDelegate { get }
}
