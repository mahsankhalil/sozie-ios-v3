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

class SignUpViewController: UIViewController, UITextFieldDelegate, ValidationDelegate {

    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var maleBtn: UIButton!
    
    @IBOutlet weak var lastNameTxtFld: MFTextField!
    @IBOutlet weak var firstNameTxtFld: MFTextField!
    @IBOutlet weak var userNameTxtFld: MFTextField!
    @IBOutlet weak var dateOfBirtTxtFld: DatePickerTextField!
    @IBOutlet weak var signUpButton: DZGradientButton!
    @IBOutlet weak var backButton: UIButton!

    let validator = Validator()
    var isFemaleSelected = false
    var signUpDict: [String: Any]?
    var tipView: EasyTipView?

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
        populateCurrentUserData()
        populateSocialData()
    }

    func populateSocialData() {
        if let firstName = signUpDict?[User.CodingKeys.firstName.stringValue] {
            firstNameTxtFld.text = firstName as? String
        }
        if let lastName = signUpDict?[User.CodingKeys.lastName.stringValue] {
            lastNameTxtFld.text = lastName as? String
        }
    }

    func populateCurrentUserData() {

        if let currentUser = UserDefaultManager.getCurrentUserObject() {
            firstNameTxtFld.text = currentUser.firstName
            lastNameTxtFld.text = currentUser.lastName
            let birthday = UtilityManager.dateFromStringWithFormat(date: currentUser.birthday, format: "yyyy-MM-dd")
            dateOfBirtTxtFld.text = UtilityManager.stringFromNSDateWithFormat(date: birthday, format: Constant.appDateFormat)
            dateOfBirtTxtFld.date = UtilityManager.dateFromStringWithFormat(date: currentUser.birthday, format: "yyyy-MM-dd") as Date
            dateOfBirtTxtFld.pickerView.date = dateOfBirtTxtFld.date!
            userNameTxtFld.text = currentUser.username
            userNameTxtFld.isUserInteractionEnabled = false
            if currentUser.gender == "F" {
                applyFemaleSelection()
            }
            signUpButton.setTitle("Save", for: .normal)
        } else {
            backButton.isHidden = true
        }
    }
    // MARK: - Custom Methods

    func applyValidators() {
        validator.registerField(firstNameTxtFld, errorLabel: nil, rules: [RequiredRule(message: "Email can't be empty") as Rule])
        validator.registerField(lastNameTxtFld, errorLabel: nil, rules: [RequiredRule(message: "Last Name can't be empty") as Rule])
        validator.registerField(userNameTxtFld, errorLabel: nil, rules: [RequiredRule(message: "Username can't be empty") as Rule])
        validator.registerField(dateOfBirtTxtFld, errorLabel: nil, rules: [RequiredRule(message: "Date of Birth can't be empty") as Rule])

        [firstNameTxtFld, lastNameTxtFld, userNameTxtFld, dateOfBirtTxtFld ].forEach { (field) in
            field?.delegate = self
        }
    }

    func verifyUsernameUniquenessFromServer(username: String?) {
        let dataDict = ["attr_type": "username", "attr_value": username!]
        SVProgressHUD.show()
        ServerManager.sharedInstance.validateEmailOrUsername(params: dataDict as [String: Any]) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            if isSuccess {
                self.signUpUser()
            } else {
                if let error = response as? Error {
                    UtilityManager.showMessageWith(title: "Please Try Again", body: error.localizedDescription, in: self)
                }
            }
        }
    }

    func signUpUser() {
        signUpDict![User.CodingKeys.firstName.stringValue] = firstNameTxtFld.text
        signUpDict![User.CodingKeys.lastName.stringValue] = lastNameTxtFld.text
        signUpDict![User.CodingKeys.username.stringValue] = userNameTxtFld.text
        signUpDict![User.CodingKeys.birthday.stringValue] = UtilityManager.stringFromNSDateWithFormat(date: dateOfBirtTxtFld.date! as NSDate, format: "YYYY-MM-dd")

        if isFemaleSelected {
            signUpDict![User.CodingKeys.gender.stringValue] = "F"
        }

        SVProgressHUD.show()
        ServerManager.sharedInstance.signUpUserWith(params: signUpDict!) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            if isSuccess {
                if let loginResponse = response as? LoginResponse {
                    _ = UserDefaultManager.saveLoginResponse(loginResp: loginResponse)
                    UtilityManager.registerUserOnIntercom()
                }
                self.performSegue(withIdentifier: "toMeasurementVC", sender: self)
            } else {
                if let error = response as? Error {
                    UtilityManager.showMessageWith(title: "Please Try Again", body: error.localizedDescription, in: self)
                }
            }
        }
    }

    func updateProfile() {
        var dataDict = [String: Any]()
        dataDict[User.CodingKeys.firstName.stringValue] = firstNameTxtFld.text
        dataDict[User.CodingKeys.lastName.stringValue] = lastNameTxtFld.text
        dataDict[User.CodingKeys.username.stringValue] = userNameTxtFld.text
        dataDict[User.CodingKeys.birthday.stringValue] = UtilityManager.stringFromNSDateWithFormat(date: dateOfBirtTxtFld.date! as NSDate, format: "YYYY-MM-dd")
        if isFemaleSelected {
            dataDict[User.CodingKeys.gender.stringValue] = "F"
        }
        SVProgressHUD.show()
        ServerManager.sharedInstance.updateProfile(params: dataDict, imageData: nil) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            if isSuccess {
                let user = response as! User
                UserDefaultManager.updateUserObject(user: user)
                self.navigationController?.popViewController(animated: true)
            } else {
                let error = response as! Error
                UtilityManager.showMessageWith(title: "Please Try Again", body: error.localizedDescription, in: self)
            }
        }
    }
    // MARK: - Validation CallBacks

    func validationSuccessful() {

        if !isFemaleSelected {
            UtilityManager.showErrorMessage(body: "Please Select gender", in: self)
        } else {
            if UserDefaultManager.isUserLoggedIn() {
                updateProfile()
            } else {
                verifyUsernameUniquenessFromServer(username: userNameTxtFld.text)
            }
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

    // MARK: - Text Field Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tipView?.dismiss()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let txtFld  = textField as? MFTextField {
            txtFld.setError(nil, animated: true)
        }
        tipView?.dismiss()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupMaterialTxtField() {
        firstNameTxtFld.underlineColor = UIColor(hex: "DADADA")
        firstNameTxtFld.placeholderColor = UIColor(hex: "888888")
        firstNameTxtFld.tintColor = UIColor(hex: "FC8888")
        firstNameTxtFld.placeholderFont = UIFont(name: "SegoeUI", size: 14.0)
    }

    func restrictToFourteenYears() {
        let fourteenYearsAgoDate =  Calendar.current.date(byAdding: .year, value: -14, to: Date())
        dateOfBirtTxtFld.pickerView.maximumDate = fourteenYearsAgoDate
    }

    func applyFemaleSelection() {
        isFemaleSelected = true
        femaleBtn.applyButtonSelected()
        maleBtn.applyButtonUnSelected()
        femaleBtn.applyButtonShadow()
        maleBtn.layer.shadowOpacity = 0.0
        tipView?.dismiss()
    }

    @IBAction func signupButtonPressed(_ sender: Any) {
        validator.validate(self)
    }

    @IBAction func femaleBtnTapped(_ sender: Any) {
        applyFemaleSelection()

    }

    @IBAction func maleBtnTapped(_ sender: Any) {
        tipView?.dismiss()
        let sozietext = "“Hi guys, We are working on your Sozie solution so that you can earn money too! Please check back in the near future for an updated version of our app”"
        let shopperText = "“Hi guys, We are working hard on a Sozie solution for you! Please look out for the updated version of our app in the near future.”"
        var text = sozietext
        if UserDefaultManager.getCurrentUserObject() != nil, let userType = UserDefaultManager.getCurrentUserType() {
            if userType == UserType.sozie.rawValue {
                text = sozietext
            } else {
                text = shopperText
            }
        } else {
            if let userType = signUpDict?[User.CodingKeys.type.stringValue] as? String {
                if userType == UserType.sozie.rawValue {
                    text = sozietext
                } else {
                    text = shopperText
                }
            }
        }
        tipView = EasyTipView(text: text, preferences: UtilityManager.tipViewGlobalPreferences(), delegate: nil)
        tipView?.show(animated: true, forView: self.maleBtn, withinSuperview: self.view)
    }

    @IBAction func backBtnTapped(_ sender: Any) {
        if UserDefaultManager.isUserLoggedIn() {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMeasurementVC" {
            let destVC = segue.destination as? MeasurementsVC
            destVC?.isFromSignUp = true
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
