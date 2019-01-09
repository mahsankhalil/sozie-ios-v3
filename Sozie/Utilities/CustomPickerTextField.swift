//
//  CustomPickerTextField.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 9/5/18.
//  Copyright © 2018 Arbisoft. All rights reserved.
//

import UIKit
import MaterialTextField

@objc protocol CustomPickerTextFieldDelegate {
    
    @objc optional func customPickerValueChanges(value1 : String? , value2 : String?)
}
class CustomPickerTextField: MFTextField, UITextFieldDelegate, UIPickerViewDelegate , UIPickerViewDataSource {
    var pickerView: UIPickerView!
    var values : [String]?
    var secondColumnValues : [String]?
    var selectedIndex : Int?
    var currentValue: String?
    var measurementType : String?
    var titleLbl : UILabel?
    var title : String?
    var firstColumnAppendingString : String?
    var secondColumnAppendingString : String?
    var pickerDelegate: CustomPickerTextFieldDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        pickerView = UIPickerView()
        let myInputView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: pickerView.frame.height+20))
        pickerView.backgroundColor = UIColor.white
        myInputView.backgroundColor = UIColor.white

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
    
    // MARK: - Custom Methods
    
    func updateTxtFldWith( rightTitle : String , placeholder : String , measurementType : String , values1 : [String]? , values2 : [String]? , title : String , firsColumStr : String , secondColumnStr : String)
    {
        self.applyRightVuLblWith(title: rightTitle)
        self.placeholder = placeholder
        self.measurementType = measurementType
        self.values = values1
        self.secondColumnValues = values2
        
        self.title = title
        self.firstColumnAppendingString = firsColumStr
        self.secondColumnAppendingString = secondColumnStr
    }
    
    
    func updateValues()
    {
        let value1 = values?[pickerView.selectedRow(inComponent: 0)]
        var value2 : String?
        if (secondColumnValues?.count)! > 0
        {
            value2 = secondColumnValues?[pickerView.selectedRow(inComponent: 1)]
            
        }
        pickerDelegate?.customPickerValueChanges?(value1: value1, value2: value2)

    }
    
    // MARK: - PickerVIew Delegates
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0
        {
            return (values?.count)!
        }
        else
        {
            return (secondColumnValues?.count)!
        }
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if self.measurementType == Constant.single
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
            return ((values?[row]) ?? "")  + (firstColumnAppendingString ?? "")
        }
        else
        {
            return (secondColumnValues?[row] ?? "") + (secondColumnAppendingString ?? "")
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        updateValues()
    }
    
    //MARK: - Textfield delegates
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

        titleLbl?.text = title
        updateValues()

    }
    
    //MARK: - IBActions
    
   
    
    @objc func pickerValueChanged(){

        updateValues()
    }
    
    @IBAction func donePickerBtnClick(sender: AnyObject){

        updateValues()
        self.endEditing(true)

    }
    
}
