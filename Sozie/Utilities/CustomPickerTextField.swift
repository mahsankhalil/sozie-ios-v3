//
//  CustomPickerTextField.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 9/5/18.
//  Copyright © 2018 Arbisoft. All rights reserved.
//

import UIKit
import MaterialTextField
class CustomPickerTextField: MFTextField, UITextFieldDelegate, UIPickerViewDelegate , UIPickerViewDataSource {
    var pickerView: UIPickerView!
    var values : [String]?
    var selectedIndex : Int?
    var currentValue: String?
    var measurementType : String?
    var titleLbl : UILabel?
    var title : String?

    override func awakeFromNib() {
        super.awakeFromNib()
        pickerView = UIPickerView()
        let myInputView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: pickerView.frame.height+20))
        pickerView.frame = CGRect(x: pickerView.frame.origin.x, y: pickerView.frame.origin.y,width: myInputView.frame.size.width, height: pickerView.frame.size.height)
        pickerView.center = CGPoint(x: myInputView.center.x, y: myInputView.center.y + 10)
        myInputView.addSubview(pickerView)
        

        
        let donePickerBtn = UIButton(frame: CGRect(x:UIScreen.main.bounds.width - 80,y: 5,width: 50,height: 30))
        donePickerBtn.setTitle("Done", for: UIControl.State.normal)
        donePickerBtn.titleLabel?.font = UIFont(name: "SegoeUI", size: 12.0)
        donePickerBtn.setTitleColor( UIColor(hex: "888888") , for: UIControl.State.normal)
        donePickerBtn.setTitleColor(Styles.sharedStyles.primaryGreyColor, for: UIControl.State.normal)
        donePickerBtn.addTarget(self, action: #selector(CustomPickerTextField.donePickerBtnClick(sender:)), for: UIControl.Event.touchUpInside)
        myInputView.addSubview(donePickerBtn)
        
        titleLbl = UILabel(frame: CGRect(x:0,y: 5,width: UIScreen.main.bounds.width,height: 30))
        titleLbl?.font = UIFont(name: "SegoeUI-Bold", size: 16.0)
        titleLbl?.textColor = UIColor(hex: "FFA4A4")
        titleLbl?.textAlignment = .center
        myInputView.addSubview(titleLbl!)
        
        self.inputView = myInputView
        self.delegate = self
        pickerView.delegate = self
        
        
    }
    
    // MARK: - PickerVIew Delegates
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0
        {
            return (values?.count)!
        }
        else
        {
            return 1
        }
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if self.measurementType == "none"
        {
            return 1
        }
        else
        {
            return 2

        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0
        {
            return values?[row]
        }
        else
        {
            return measurementType
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.text = values?[pickerView.selectedRow(inComponent: 0)]

    }
    
    //MARK: - Textfield delegates
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

        self.text = values?[pickerView.selectedRow(inComponent: 0)]
        titleLbl?.text = title
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "datePickerTextFieldTextChanged"), object: nil)
    }
    
    //MARK: - IBActions
    
   
    
    @objc func pickerValueChanged(){

        self.text = values?[pickerView.selectedRow(inComponent: 0)]

    }
    
    @IBAction func donePickerBtnClick(sender: AnyObject){

        self.text = values?[pickerView.selectedRow(inComponent: 0)]

        self.endEditing(true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "datePickerTextFieldTextChanged"), object: nil)
    }
    
}
