//
//  DoubleTextFieldCell.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/9/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
class DoubleTextFieldCell: UITableViewCell, CustomPickerTextFieldDelegate {

    @IBOutlet weak var secondTxtFld: CustomPickerTextField!
    @IBOutlet weak var firstTxtFld: CustomPickerTextField!

    weak var textFieldDelegate: TextFieldDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
        firstTxtFld.setupAppDesign()
        secondTxtFld.setupAppDesign()
        firstTxtFld.pickerDelegate = self
        secondTxtFld.pickerDelegate = self
    }

    func customPickerValueChanges(instance: CustomPickerTextField, value1: String?, value2: String?) {
        if let text = value1 {
            instance.text = text
            var firstText = ""
            var secondText = ""
            if let text1 = firstTxtFld.text {
                firstText = text1
            }
            if let text2 = secondTxtFld.text {
                secondText = text2
            }
            textFieldDelegate?.textFieldDidUpdate(self, textField1: firstText, textField2: secondText)
        }
//        if let text1 = value1 , let text2 = value2 {
//            firstTxtFld.text = value1
//            secondTxtFld.text = value2
//            textFieldDelegate?.textFieldDidUpdate(self, textField1: text1, textField2: text2)
//        } else if let text1 = value1 {
//            firstTxtFld.text = value1
//            textFieldDelegate?.textFieldDidUpdate(self, textField1: text1, textField2: "")
//
//        } else if let text2 = value2 {
//            secondTxtFld.text = value2
//            textFieldDelegate?.textFieldDidUpdate(self, textField1: "", textField2: text2)
//        }
//        guard let text1 = value1, let text2 = value2 else { return }
//        firstTxtFld.text = value1
//        secondTxtFld.text = value2
//        textFieldDelegate?.textFieldDidUpdate(self, textField1: firstTxtFld.text, textField2: secondTxtFld.text)
    }
}

extension DoubleTextFieldCell: CellConfigurable {
    func setup(_ viewModel: RowViewModel) {
        if let doubleTextFieldCellViewModel = viewModel as? DoubleTextFieldCellViewModeling {
            firstTxtFld.configure(title: doubleTextFieldCellViewModel.title1, placeholder: doubleTextFieldCellViewModel.columnPlaceholder[0], values: doubleTextFieldCellViewModel.columnValues[0], valuesSuffix:  doubleTextFieldCellViewModel.columnValueSuffix[0])
            secondTxtFld.configure(title: doubleTextFieldCellViewModel.title2, placeholder: doubleTextFieldCellViewModel.columnPlaceholder[1], values: doubleTextFieldCellViewModel.columnValues[1], valuesSuffix:  doubleTextFieldCellViewModel.columnValueSuffix[1])
//            firstTxtFld.configure(title: doubleTextFieldCellViewModel.title, rightTitle: doubleTextFieldCellViewModel.columnUnit[0], placeholder: doubleTextFieldCellViewModel.columnPlaceholder[0], values1: doubleTextFieldCellViewModel.columnValues[0], values1Suffix: doubleTextFieldCellViewModel.columnValueSuffix[0], values2: doubleTextFieldCellViewModel.columnValues[1], values2Suffix: doubleTextFieldCellViewModel.columnValueSuffix[1])
//            secondTxtFld.configure(title: doubleTextFieldCellViewModel.title, rightTitle: doubleTextFieldCellViewModel.columnUnit[1], placeholder: doubleTextFieldCellViewModel.columnPlaceholder[1], values1: doubleTextFieldCellViewModel.columnValues[0], values1Suffix: doubleTextFieldCellViewModel.columnValueSuffix[0], values2: doubleTextFieldCellViewModel.columnValues[1], values2Suffix: doubleTextFieldCellViewModel.columnValueSuffix[1])
            if let text = doubleTextFieldCellViewModel.text1 {
                firstTxtFld.text = text
                firstTxtFld.currentValue1 = text
                if let text2 = doubleTextFieldCellViewModel.text2 {
                    firstTxtFld.currentValue2 = text2
                }
            }
            if let text = doubleTextFieldCellViewModel.text2 {
                secondTxtFld.text = text
                secondTxtFld.currentValue2 = text
                if let text2 = doubleTextFieldCellViewModel.text1 {
                    secondTxtFld.currentValue1 = text2
                }

            }
            self.textFieldDelegate = doubleTextFieldCellViewModel.textFieldDelegate
        }
        if let errorModel = viewModel as? ErrorViewModeling {
            if errorModel.displayError, let errorMessageModel = viewModel as? ErrorMessageViewModeling {
                firstTxtFld.setError(CustomError(str: errorMessageModel.errorMessage), animated: true)
            } else {
                firstTxtFld.setError(nil, animated: true)
            }
        }
    }
}
