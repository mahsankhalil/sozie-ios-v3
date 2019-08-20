//
//  DoubleTextFieldCellViewModel.swift
//  Sozie
//
//  Created by Omair Baskanderi on 2019-01-26.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import Foundation

struct DoubleTextFieldCellViewModel: DoubleTextFieldCellViewModeling, ErrorMessageViewModeling, ReuseIdentifierProviding,
ErrorViewModeling, MeasurementTypeProviding, RowViewModel {
    var text1: String?
    var text2: String?
    var title1: String
    var title2: String
    var columnUnit: [String]
    var columnPlaceholder: [String]
    var columnValueSuffix: [String]
    var columnValues: [[String]]
    var textFieldDelegate: TextFieldDelegate
    var displayError: Bool
    var errorMessage: String
    var measurementType: MeasurementType
    let reuseIdentifier = "DoubleTextFieldCell"
}
