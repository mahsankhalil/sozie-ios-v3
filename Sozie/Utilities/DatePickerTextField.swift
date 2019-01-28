//
//  PickerTextField.swift
//  MyRxReminder
//
//  Created by Danial Zahid on 11/30/15.
//  Copyright © 2015 Danial Zahid. All rights reserved.
//

import UIKit
import MaterialTextField
class DatePickerTextField: MFTextField, UITextFieldDelegate {

    var pickerView: UIDatePicker!
    var values: [String]?
    var selectedIndex: Int?
    var date: Date?
    var title: String?
    var titleLbl: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        pickerView = UIDatePicker()
        let myInputView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: pickerView.frame.height+20))
        myInputView.backgroundColor = UIColor.white
        pickerView.frame = CGRect(x: pickerView.frame.origin.x, y: pickerView.frame.origin.y,width: myInputView.frame.size.width, height: pickerView.frame.size.height)
        pickerView.backgroundColor = UIColor.white
        pickerView.center = CGPoint(x: myInputView.center.x, y: myInputView.center.y + 10)
        myInputView.addSubview(pickerView)
        
        pickerView.datePickerMode = UIDatePicker.Mode.date
        pickerView.addTarget(self, action: #selector(DatePickerTextField.pickerValueChanged), for: UIControl.Event.valueChanged)
        
        let donePickerBtn = UIButton(frame: CGRect(x:UIScreen.main.bounds.width - 80,y: 5,width: 50,height: 30))
        donePickerBtn.setTitle("Done", for: UIControl.State.normal)
        
        donePickerBtn.titleLabel?.font = UIFont(name: "SegoeUI", size: 12.0)
        donePickerBtn.setTitleColor( UIColor(hex: "888888") , for: UIControl.State.normal)
        donePickerBtn.addTarget(self, action: #selector(DatePickerTextField.donePickerBtnClick(sender:)), for: UIControl.Event.touchUpInside)
        myInputView.addSubview(donePickerBtn)
        
        titleLbl = UILabel(frame: CGRect(x:0,y: 5,width: UIScreen.main.bounds.width,height: 30))
        titleLbl?.font = UIFont(name: "SegoeUI-Bold", size: 16.0)
        titleLbl?.textColor = UIColor(hex: "FFA4A4")
        titleLbl?.textAlignment = .center
        myInputView.addSubview(titleLbl!)

        self.inputView = myInputView
        self.inputView?.layer.cornerRadius = 10.0
        self.inputView?.clipsToBounds = true
        self.delegate = self
    }

    //MARK: - Textfield delegates
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.text = UtilityManager.stringFromNSDateWithFormat(date: pickerView.date as NSDate, format: Constant.appDateFormat)
        self.date = pickerView.date
        titleLbl?.text = title

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "datePickerTextFieldTextChanged"), object: nil)
    }
    
    //MARK: - IBActions
    
    @objc func pickerValueChanged(){
        self.text = UtilityManager.stringFromNSDateWithFormat(date: pickerView.date as NSDate, format: Constant.appDateFormat)
        self.date = pickerView.date
    }
    
    @IBAction func donePickerBtnClick(sender: AnyObject){
        self.text = UtilityManager.stringFromNSDateWithFormat(date: pickerView.date as NSDate, format: Constant.appDateFormat)
        self.date = pickerView.date
        self.endEditing(true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "datePickerTextFieldTextChanged"), object: nil)
    }

}
