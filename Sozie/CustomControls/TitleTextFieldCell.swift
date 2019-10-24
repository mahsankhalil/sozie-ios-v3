//
//  TitleTextFieldCell.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 6/12/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class TitleTextFieldCell: UITableViewCell {
    @IBOutlet weak var textField: CustomPickerTextField!
    weak private var textFieldDelegate: TextFieldDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField.setupAppDesign()
        textField.pickerDelegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
extension TitleTextFieldCell: CustomPickerTextFieldDelegate {
    func customPickerValueChanges(instance: CustomPickerTextField, value1: String?, value2: String?) {
        if let text = value1 {
            if text != "" {
                textField.text = text
            }
            textFieldDelegate?.textFieldDidUpdate(self, text: text)
        }
    }
}
extension TitleTextFieldCell: CellConfigurable {
    func setup(_ viewModel: RowViewModel) {
        if let model = viewModel as? TextFieldCellViewModeling {
            textField.configure(title: model.title, placeholder: model.title, values: model.values, valuesSuffix: "")
//            self.buttonTappedDelegate = model.buttonTappedDelegate
            self.textFieldDelegate = model.textFieldDelegate
            if let text = model.text {
                if text != "" {
                    textField.currentValue1 = text
                    textField.text = text
                }
            }
        }
        if let errorModel = viewModel as? ErrorViewModeling {
            if errorModel.displayError, let errorMessageModel = viewModel as? ErrorMessageViewModeling {
                textField.setError(CustomError(str: errorMessageModel.errorMessage), animated: true)
            } else {
                textField.setError(nil, animated: true)
            }
        }
    }
}
