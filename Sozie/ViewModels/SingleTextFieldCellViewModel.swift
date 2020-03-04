//
//  SingleTextFieldCellViewModel.swift
//  Sozie
//
//  Created by Omair Baskanderi on 2019-01-26.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import Foundation

struct SingleTextFieldCellViewModel: SingleTextFieldCellViewModeling, ErrorMessageViewModeling, ReuseIdentifierProviding,
ErrorViewModeling, MeasurementTypeProviding, RowViewModel {
    var title: String
    var text: String?
    var placeholder: String
    var values: [String]
    var valueSuffix: String
    weak var buttonTappedDelegate: ButtonTappedDelegate?
    weak var textFieldDelegate: TextFieldDelegate?
    var displayError: Bool
    var errorMessage: String
    var measurementType: MeasurementType
    var columnUnit: String
    let reuseIdentifier = "SingleTextFieldCell"
}
