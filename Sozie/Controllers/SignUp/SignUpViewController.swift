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
import TPKeyboardAvoiding

class SignUpViewController: UIViewController, UITextFieldDelegate, ValidationDelegate, UITextViewDelegate {

    @IBOutlet weak var termsConditionTextView: UITextView!
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var lastNameTxtFld: MFTextField!
    @IBOutlet weak var firstNameTxtFld: MFTextField!
    @IBOutlet weak var userNameTxtFld: MFTextField!
    @IBOutlet weak var dateOfBirtTxtFld: DatePickerTextField!
    @IBOutlet weak var signUpButton: DZGradientButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
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
        makeAttributedTextView()
    }
    func makeAttributedTextView() {
        let text = NSMutableAttributedString(string: "By tapping \"Sign Up\" you agree to our ")
        let text2 = NSMutableAttributedString(string: " and ")
        text.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 10), range: NSMakeRange(0, text.length))
        text2.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 10), range: NSMakeRange(0, text2.length))
        text2.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hex: "A9A9A9"), range: NSMakeRange(0, text2.length))
        text.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hex: "A9A9A9"), range: NSMakeRange(0, text.length))

        let selectablePart = NSMutableAttributedString(string: "Terms & Conditions")
        let selectablePart2 = NSMutableAttributedString(string: "Privacy Policy")

        selectablePart2.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 10), range: NSMakeRange(0, selectablePart2.length))
        selectablePart.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hex: "92BFFE"), range: NSMakeRange(0, selectablePart.length))
        selectablePart2.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hex: "92BFFE"), range: NSMakeRange(0, selectablePart2.length))

        // Add an underline to indicate this portion of text is selectable (optional)
        selectablePart2.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSMakeRange(0, selectablePart2.length))
        // Add an NSLinkAttributeName with a value of an url or anything else
        selectablePart2.addAttribute(NSAttributedString.Key.link, value: "privacy", range: NSMakeRange(0, selectablePart2.length))
        selectablePart.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 10), range: NSMakeRange(0, selectablePart.length))
        // Add an underline to indicate this portion of text is selectable (optional)
        selectablePart.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSMakeRange(0, selectablePart.length))
        // Add an NSLinkAttributeName with a value of an url or anything else
        selectablePart.addAttribute(NSAttributedString.Key.link, value: "terms", range: NSMakeRange(0, selectablePart.length))
        // Combine the non-selectable string with the selectable string
        
        text.append(selectablePart)
        text.append(text2)
        text.append(selectablePart2)
        // Center the text (optional)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        text.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, text.length))
        // To set the link text color (optional)
        // Set the text view to contain the attributed text
        termsConditionTextView.attributedText = text
        // Disable editing, but enable selectable so that the link can be selected
        termsConditionTextView.isEditable = false
        termsConditionTextView.isSelectable = true
        // Set the delegate in order to use textView(_:shouldInteractWithURL:inRange)
        termsConditionTextView.delegate = self
    }
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        // **Perform sign in action here**
        if URL.absoluteString == "terms" {
            let storyBoard = UIStoryboard(name: "TabBar", bundle: Bundle.main)
            let tosVC = storyBoard.instantiateViewController(withIdentifier: "TermsOfServiceVC") as! TermsOfServiceVC
            tosVC.type = TOSType.termsCondition
            self.present(tosVC, animated: true, completion: nil)
        } else if URL.absoluteString == "privacy" {
            let storyBoard = UIStoryboard(name: "TabBar", bundle: Bundle.main)
            let tosVC = storyBoard.instantiateViewController(withIdentifier: "TermsOfServiceVC") as! TermsOfServiceVC
            tosVC.type = TOSType.privacyPolicy
            self.present(tosVC, animated: true, completion: nil)
        }
        return false
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
            termsConditionTextView.isHidden = true
        } else {
            backButton.isHidden = true
            termsConditionTextView.isHidden = false
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
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        signUpDict!["version"]  = appVersion
        SVProgressHUD.show()
        ServerManager.sharedInstance.signUpUserWith(params: signUpDict!) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            if isSuccess {
                if let loginResponse = response as? LoginResponse {
                    _ = UserDefaultManager.saveLoginResponse(loginResp: loginResponse)
//                    UtilityManager.registerUserOnIntercom()
                }
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.updatePushTokenToServer()
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
