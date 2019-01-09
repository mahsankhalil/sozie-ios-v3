//
//  SignUpViewController.swift
//  Quicklic
//
//  Created by Danial Zahid on 25/08/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit
import SwiftValidator
import MaterialTextField
class SignUpViewController: UIViewController {
    
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var maleBtn: UIButton!
    
    @IBOutlet weak var lastNameTxtFld: MFTextField!
    @IBOutlet weak var firstNameTxtFld: MFTextField!
    @IBOutlet weak var userNameTxtFld: MFTextField!
    @IBOutlet weak var dateOfBirtTxtFld: DatePickerTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        maleBtn.applyButtonUnSelected()
        femaleBtn.applyButtonUnSelected()
        
        dateOfBirtTxtFld.title = "DATE OF BIRTH"
        restrictToFourteenYears()
        firstNameTxtFld.setupAppDesign()
        lastNameTxtFld.setupAppDesign()
        userNameTxtFld.setupAppDesign()
        dateOfBirtTxtFld.setupAppDesign()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupMaterialTxtField()
    {
        firstNameTxtFld.underlineColor = UIColor(hex: "DADADA")
        firstNameTxtFld.placeholderColor = UIColor(hex: "888888")
        firstNameTxtFld.tintColor = UIColor(hex: "FC8888")
        firstNameTxtFld.placeholderFont = UIFont(name: "SegoeUI", size: 14.0)
    }
    func restrictToFourteenYears()
    {
        //        let fourteenYearInterval = TimeInterval(14 * 60 * 60 * 24 * 365)
        
        let fourteenYearsAgoDate =  Calendar.current.date(byAdding: .year, value: -14, to: Date())
        dateOfBirtTxtFld.pickerView.maximumDate = fourteenYearsAgoDate
    }
    
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        
    }
    
    
    
    @IBAction func femaleBtnTapped(_ sender: Any) {
        
        femaleBtn.applyButtonSelected()
        maleBtn.applyButtonUnSelected()
        femaleBtn.applyButtonShadow()
        
        maleBtn.layer.shadowOpacity = 0.0
        
    }
    
    @IBAction func maleBtnTapped(_ sender: Any) {
        
        maleBtn.applyButtonSelected()
        femaleBtn.applyButtonUnSelected()
        maleBtn.applyButtonShadow()
        femaleBtn.layer.shadowOpacity = 0.0
    }
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
        
    }
    
}
