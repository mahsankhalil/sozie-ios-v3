//
//  CustomPickerTextField.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 9/5/18.
//  Copyright © 2018 Arbisoft. All rights reserved.
//

import UIKit
import MaterialTextField

protocol CustomPickerTextFieldDelegate: class {
    func customPickerValueChanges(instance: CustomPickerTextField, value1: String?, value2: String?)
}

class CustomPickerTextField: MFTextField, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    var pickerView: UIPickerView!
    var values1: [String]?
    var values2: [String]?
    var currentValue1: String?
    var currentValue2: String?
    var titleLabel: UILabel?
    var title: String?
    var firstColumnAppendingString: String?
    var secondColumnAppendingString: String?
    weak var pickerDelegate: CustomPickerTextFieldDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        pickerView = UIPickerView()
        let myInputView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: pickerView.frame.height + 55))
        pickerView.backgroundColor = UIColor.white
        myInputView.backgroundColor = UIColor.white
        pickerView.frame = CGRect(x: pickerView.frame.origin.x, y: pickerView.frame.origin.y, width: myInputView.frame.size.width, height: pickerView.frame.size.height)
        pickerView.center = CGPoint(x: myInputView.center.x, y: myInputView.center.y + 10)
        myInputView.addSubview(pickerView)
        let donePickerBtn = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 50, y: 5, width: 50, height: 30))
        donePickerBtn.setTitle("Done", for: UIControl.State.normal)
        donePickerBtn.titleLabel?.font = UIFont(name: "SegoeUI", size: 12.0)
        donePickerBtn.setTitleColor( UIColor(hex: "888888"), for: UIControl.State.normal)
        donePickerBtn.setTitleColor(Styles.sharedStyles.primaryGreyColor, for: UIControl.State.normal)
        donePickerBtn.addTarget(self, action: #selector(CustomPickerTextField.donePickerBtnClick(sender:)), for: UIControl.Event.touchUpInside)
        myInputView.addSubview(donePickerBtn)
        titleLabel = UILabel(frame: CGRect(x: 0, y: 35, width: UIScreen.main.bounds.width, height: 30))
        titleLabel?.font = UIFont(name: "SegoeUI-Bold", size: 14.0)
        titleLabel?.textColor = UIColor(hex: "FFA4A4")
        titleLabel?.textAlignment = .center
        titleLabel?.numberOfLines = 0
        myInputView.addSubview(titleLabel!)
        self.inputView = myInputView
        self.delegate = self
        pickerView.delegate = self
    }

    // MARK: - Custom Methods

    func configure(title: String, placeholder: String, values: [String], valuesSuffix: String) {
        self.title = title
        self.placeholder = placeholder
        self.values1 = values
        self.firstColumnAppendingString = valuesSuffix
    }

    func configure(title: String, rightTitle: String, placeholder: String, values1: [String], values1Suffix: String, values2: [String], values2Suffix: String) {
        self.configure(title: title, placeholder: placeholder, values: values1, valuesSuffix: values1Suffix)
        self.applyRightVuLblWith(title: rightTitle)
        self.values2 = values2
        self.secondColumnAppendingString = values2Suffix
    }
    func getindexInArray(allValues: [String], currentValue: String) -> Int {
        for index in 0..<allValues.count where currentValue == allValues[index] {
            return index
        }
        return 0
    }

    func updateValues() {
        guard let delegate = pickerDelegate else { return  }
        let value1 = values1?[pickerView.selectedRow(inComponent: 0)]
        var value2: String?
        if let values2 = values2, values2.count > 0 {
            value2 = values2[pickerView.selectedRow(inComponent: 1)]
        }
        delegate.customPickerValueChanges(instance: self ,value1: value1, value2: value2)
    }

    // MARK: - PickerVIew Delegates
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return (values1?.count) ?? 0
        } else {
            return (values2?.count) ?? 0
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        var numberOfComponents = 0
        if values1 != nil {
            numberOfComponents += 1
        }
        if values2 != nil {
            numberOfComponents += 1
        }
        return numberOfComponents
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return ((values1?[row]) ?? "")  + (firstColumnAppendingString ?? "")
        } else {
            return (values2?[row] ?? "") + (secondColumnAppendingString ?? "")
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateValues()
    }
    // MARK: - Textfield delegates

    func textFieldDidBeginEditing(_ textField: UITextField) {
        titleLabel?.text = title
        if let values = values1, let currentValue = currentValue1 {
            let index = getindexInArray(allValues: values, currentValue: currentValue)
            pickerView.selectRow(index, inComponent: 0, animated: false)
        }
        if let values = values2, let currentValue = currentValue2 {
            let index = getindexInArray(allValues: values, currentValue: currentValue)
            pickerView.selectRow(index, inComponent: 1, animated: false)
        }
        updateValues()
    }

    // MARK: - IBActions

    @objc func pickerValueChanged() {
        updateValues()
    }

    @IBAction func donePickerBtnClick(sender: AnyObject) {
        updateValues()
        self.endEditing(true)
    }
}
