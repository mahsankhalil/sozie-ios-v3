//
//  SingleTextFieldCell.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/9/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import MaterialTextField

class SingleTextFieldCell: UITableViewCell {

    @IBOutlet weak var textField: CustomPickerTextField!
    @IBOutlet weak var notSureButton: UIButton!

    weak private var buttonTappedDelegate: ButtonTappedDelegate?
    private var textFieldDelegate: TextFieldDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField.setupAppDesign()
        textField.pickerDelegate = self
    }

    @IBAction func onButtonTapped(_ sender: Any) {
        buttonTappedDelegate?.onButtonTappedDelegate(sender)
    }
}

extension SingleTextFieldCell: UIButtonProviding {
    var button: UIButton {
        return notSureButton
    }
}

extension SingleTextFieldCell: CustomPickerTextFieldDelegate {
    func customPickerValueChanges(instance: CustomPickerTextField, value1: String?, value2: String?) {
        if let text = value1 {
            textField.text = text
            textFieldDelegate?.textFieldDidUpdate(self, text: text)
        }
    }
}

extension SingleTextFieldCell: CellConfigurable {
    func setup(_ viewModel: RowViewModel) {
        if let model = viewModel as? SingleTextFieldCellViewModeling {
            textField.configure(title: model.title, placeholder: model.placeholder, values: model.values, valuesSuffix: model.valueSuffix)
            self.buttonTappedDelegate = model.buttonTappedDelegate
            self.textFieldDelegate = model.textFieldDelegate
            if let text = model.text {
                textField.currentValue1 = text
                textField.text = text
            }
            textField.applyRightVuLblWith(title: model.columnUnit)

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
