//
//  TitleTextFieldCellViewModel.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 6/12/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct TitleTextFieldCellViewModel: RowViewModel, TextFieldCellViewModeling, ReuseIdentifierProviding, MeasurementTypeProviding, ErrorViewModeling, ErrorMessageViewModeling {
    var title: String
    var text: String?
    var values: [String]
    var measurementType: MeasurementType
    weak var textFieldDelegate: TextFieldDelegate?
    var errorMessage: String
    var displayError: Bool
    let reuseIdentifier: String = "TitleTextFieldCell"
}
