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
import SVProgressHUD
import EasyTipView
class SignUpViewController: UIViewController , UITextFieldDelegate , ValidationDelegate {

    
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var maleBtn: UIButton!
    
    @IBOutlet weak var lastNameTxtFld: MFTextField!
    @IBOutlet weak var firstNameTxtFld: MFTextField!
    @IBOutlet weak var userNameTxtFld: MFTextField!

    let validator = Validator()


    var isFemaleSelected = false
    var signUpDict : [String: Any]?

    var tipVu : EasyTipView?
    
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
        applyValidators()
        populateSocialData()
        
      
    }
    
    func populateSocialData()
    {
        if let firstName = signUpDict![User.CodingKeys.firstName.stringValue]
        {
            firstNameTxtFld.text = firstName as? String
        }
        if let lastName = signUpDict![User.CodingKeys.lastName.stringValue]
        {
            lastNameTxtFld.text = lastName as? String
        }
        
        
    }
    //MARK: - Custom Methods
    func applyValidators() {
        validator.registerField(firstNameTxtFld, errorLabel: nil, rules: [RequiredRule(message: "Email can't be empty") as Rule,])
        validator.registerField(lastNameTxtFld, errorLabel: nil, rules: [RequiredRule(message: "Last Name can't be empty") as Rule,])
        validator.registerField(userNameTxtFld, errorLabel: nil, rules: [RequiredRule(message: "Username can't be empty") as Rule,])
        validator.registerField(dateOfBirtTxtFld, errorLabel: nil, rules: [RequiredRule(message: "Date of Birth can't be empty") as Rule,])

        
        [firstNameTxtFld, lastNameTxtFld , userNameTxtFld ].forEach { (field) in
            field?.delegate = self
        }
        
        
        
        
    }
    
    func verifyUsernameUniquenessFromServer(username : String?)
    {
        let dataDict = ["attr_type" : "username" , "attr_value" : username!]
        SVProgressHUD.show()
        ServerManager.sharedInstance.validateEmailOrUsername(params: dataDict as [String : Any]) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            if isSuccess
            {
                self.signUpUser()
            }
            else
            {
                let error = response as! Error
                UtilityManager.showMessageWith(title: "Please Try Again", body: error.localizedDescription, in: self)
                
            }
        }

    }
    
    func signUpUser()
    {
        signUpDict![User.CodingKeys.firstName.stringValue] = firstNameTxtFld.text
        signUpDict![User.CodingKeys.lastName.stringValue] = lastNameTxtFld.text
        signUpDict![User.CodingKeys.username.stringValue] = userNameTxtFld.text
        signUpDict![User.CodingKeys.birthday.stringValue] = UtilityManager.stringFromNSDateWithFormat(date: dateOfBirtTxtFld.date! as NSDate, format: "YYYY-MM-dd")
        if isFemaleSelected
        {
            signUpDict![User.CodingKeys.gender.stringValue] = "Female"
        }
        SVProgressHUD.show()
        ServerManager.sharedInstance.signUpUserWith(params: signUpDict!) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            if isSuccess
            {
                let res = response as! LoginResponse
                
                _ = UserDefaultManager.saveLoginResponse(loginResp: res)
                self.performSegue(withIdentifier: "toMeasurementVC", sender: self)
            }
            else
            {
                let error = response as! Error
                UtilityManager.showMessageWith(title: "Please Try Again", body: error.localizedDescription, in: self)
            }
        }
        
        
        
    }
    
    
    // MARK: - Validation CallBacks

    func validationSuccessful() {
        
        if !isFemaleSelected
        {
            UtilityManager.showErrorMessage(body: "Please Select gender", in: self)

        }
        else
        {
            verifyUsernameUniquenessFromServer(username: userNameTxtFld.text)
        }
        
        
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        for (field, error) in errors {
            if let field = field as? MFTextField {
                
                _ = field.resignFirstResponder()
                field.setError(CustomError(str: error.errorMessage), animated: true)
                
                
            }
        }
    }
    
    //MARK: - Text Field Delegates
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let txtFld  = textField as! MFTextField
        txtFld.setError(nil, animated: true)
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

        validator.validate(self)
    }
    
    
    
    @IBAction func femaleBtnTapped(_ sender: Any) {
        
        isFemaleSelected = true
        femaleBtn.applyButtonSelected()
        maleBtn.applyButtonUnSelected()
        femaleBtn.applyButtonShadow()
        
        maleBtn.layer.shadowOpacity = 0.0
        tipVu?.dismiss()
        
    }
    
    @IBAction func maleBtnTapped(_ sender: Any) {
        tipVu?.dismiss()
        var preferences = EasyTipView.globalPreferences
        preferences.drawing.foregroundColor = UIColor.white
        preferences.drawing.backgroundColor = UIColor(hex: "5CCEC4")
        preferences.drawing.font = UIFont(name: "SegoeUI", size: 11)!
        preferences.drawing.textAlignment = NSTextAlignment.left
        
        preferences.animating.dismissTransform = CGAffineTransform(translationX: 0, y: -15)
        preferences.animating.showInitialTransform = CGAffineTransform(translationX: 0, y: 15)
        preferences.animating.showInitialAlpha = 0
        preferences.animating.showDuration = 1
        preferences.animating.dismissDuration = 1.0
        preferences.drawing.arrowPosition = .bottom
        preferences.drawing.cornerRadius = 10.0
        preferences.positioning.maxWidth = 143
        
        let text = "“Hi guys, We are working on your Sozie solution so that you can earn money too! Please check back in the near future for an updated version of our app”"
        
        tipVu = EasyTipView(text: text, preferences: preferences, delegate: nil)
        tipVu?.show(animated: true, forView: self.maleBtn, withinSuperview: self.view)
        
    
        
        
//        maleBtn.applyButtonSelected()
//        femaleBtn.applyButtonUnSelected()
//        maleBtn.applyButtonShadow()
//        femaleBtn.layer.shadowOpacity = 0.0
    }
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
        
    }
    

}

extension SignUpViewController: SignUpInfoProvider {
    var signUpInfo: [String: Any]? {
        get { return signUpDict }
        set (newInfo) {
            signUpDict = newInfo
        }
    }
}
