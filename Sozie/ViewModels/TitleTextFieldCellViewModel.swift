//
//  TitleTextFieldCellViewModel.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 6/12/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct TitleTextFieldCellViewModel: RowViewModel, TextFieldCellViewModeling, ReuseIdentifierProviding, MeasurementTypeProviding {
    var title: String
    var text: String?
    var values: [String]
    var measurementType: MeasurementType
    var textFieldDelegate: TextFieldDelegate
    let reuseIdentifier: String = "TitleTextFieldCell"
}
