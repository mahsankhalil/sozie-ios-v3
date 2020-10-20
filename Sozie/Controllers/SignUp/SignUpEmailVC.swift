//
//  SignUpEmailVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/3/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import MaterialTextField
import SwiftValidator
import SVProgressHUD
import GoogleSignIn
import TPKeyboardAvoiding
import AuthenticationServices
class SignUpEmailVC: UIViewController, UITextFieldDelegate, ValidationDelegate, GIDSignInDelegate, GIDSignInUIDelegate {

    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!

    @IBOutlet weak var emailTxtFld: MFTextField!
    @IBOutlet weak var passwordTxtFld: MFTextField!
    @IBOutlet weak var confirmPasswordTxtFld: MFTextField!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var showConfirmPasswordBtn: UIButton!
    @IBOutlet weak var showPasswordBtn: UIButton!
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var nextBtn: DZGradientButton!
    let validator = Validator()
    var signUpDict: [String: Any]?

    @IBOutlet weak var socialButtonViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginAppleButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var appleLoginButtonView: UIView!
    @IBOutlet weak var pasteButton: UIButton!
    @IBOutlet weak var whatsThisButton: UIButton!
    @IBOutlet weak var referralCodeTextField: MFTextField!
    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emailTxtFld.setupAppDesign()
        passwordTxtFld.setupAppDesign()
        confirmPasswordTxtFld.setupAppDesign()
        referralCodeTextField.setupAppDesign()
        referralCodeTextField.placeholderAnimatesOnFocus = true
        applyValidators()
        self.whatsThisButton.alpha = 0.0
        setupAppleLoginButton()
//        if let countryId = signUpDict![User.CodingKeys.country.stringValue] as? Int {
//            if countryId == 1 {
//                self.referralCodeTextField.isHidden = true
//                self.whatsThisButton.isHidden = true
//                self.pasteButton.isHidden = true
//            }
//        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let linkedWith = appDelegate.codeLinkedWith {
            if linkedWith == "brand" {
                self.referralCodeTextField.isHidden = true
                self.whatsThisButton.isHidden = true
                self.pasteButton.isHidden = true
            }
        }
    }
    func setupAppleLoginButton() {
        if #available(iOS 13, *) {
            let customAppleLoginButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 56.0, height: 44.0))
            customAppleLoginButton.setImage(UIImage(named: "Apple Iocn"), for: .normal)
            customAppleLoginButton.addTarget(self, action: #selector(handleLogInWithAppleIDButtonPress), for: .touchUpInside)
            self.appleLoginButtonView.addSubview(customAppleLoginButton)
        } else {
            self.loginAppleButtonWidthConstraint.constant = 0.0
            self.socialButtonViewWidthConstraint.constant = 112.0
        }
    }
    @objc private func handleLogInWithAppleIDButtonPress() {
        if #available(iOS 13, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    // MARK: - Custom Methods
    func applyValidators() {
        validator.registerField(emailTxtFld, errorLabel: nil, rules: [RequiredRule(message: "Please enter a valid email address") as Rule, EmailRule(message: "Invalid email")])
        validator.registerField(passwordTxtFld, errorLabel: nil, rules: [RequiredRule(message: "Password can't be empty") as Rule, MinLengthRule(length: 8) as Rule, MaxLengthRule(length: 20) as Rule])
        [emailTxtFld, passwordTxtFld, referralCodeTextField].forEach { (field) in
            field?.delegate = self
        }
    }

    func verifyEmailFromServer(email: String?) {
        let dataDict = ["attr_type": "email", "attr_value": email!]
        SVProgressHUD.show()
        ServerManager.sharedInstance.validateEmailOrUsername(params: dataDict as [String: Any]) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            if isSuccess {
                if self.referralCodeTextField.text?.isEmpty == true {
                    self.performSegue(withIdentifier: "toSignUpPersonalInfo", sender: self)
                } else {
                    self.verifyReferralCodeFromServer()
                }
            } else {
                let error = response as! Error
                UtilityManager.showMessageWith(title: "Please Try Again", body: error.localizedDescription, in: self)
            }
        }
    }
    func verifyReferralCodeFromServer() {
        if self.referralCodeTextField.text?.isEmpty == false {
            SVProgressHUD.show()
            var dataDict = [String: Any]()
            dataDict["code"] = self.referralCodeTextField.text?.uppercased()
            ServerManager.sharedInstance.verifyReferalCode(params: dataDict) { (isSuccess, response) in
                if isSuccess {
                    let referralResponse = response as! ReferalVerificationResponse
                    if referralResponse.isValid == true {
                        self.performSegue(withIdentifier: "toSignUpPersonalInfo", sender: self)
                    } else {
                        if let detail = referralResponse.detail {
                            UtilityManager.showErrorMessage(body: detail, in: self)
                        }
                    }
                } else {
                    let error = response as! Error
                    UtilityManager.showErrorMessage(body: error.localizedDescription, in: self)
                }
            }
        }
    }
    // MARK: - Validation CallBacks
    func validationSuccessful() {
        if passwordTxtFld.text != confirmPasswordTxtFld.text {
            UtilityManager.showMessageWith(title: "Passwords do not match", body: "", in: self)
        } else {
            signUpDict![User.CodingKeys.email.stringValue] = emailTxtFld.text
            signUpDict!["password"] = passwordTxtFld.text
            signUpDict!["referral_code"] = referralCodeTextField.text?.uppercased()
            confirmPasswordTxtFld.setError( nil, animated: true)
            verifyEmailFromServer(email: emailTxtFld.text)
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
    func textFieldDidEndEditing(_ textField: UITextField) {
        let txtFld  = textField as! MFTextField
        txtFld.setError(nil, animated: true)
        if textField == referralCodeTextField {
            if textField.text == "" {
                hideWhatsThisButton()
            }
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == referralCodeTextField {
            showWhatsThisButton()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField == referralCodeTextField {
//            let  char = string.cString(using: String.Encoding.utf8)!
//            let isBackSpace = strcmp(char, "\\b")
//            if isBackSpace == -92 {
//                if textField.text?.count == 1 {
//                    self.hideWhatsThisButton()
//                }
//            } else {
//                self.showWhatsThisButton()
//            }
//        }
//        return true
//    }
    func showWhatsThisButton() {
        UIView.animate(withDuration: 0.3*0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.whatsThisButton.alpha = 1.0
            self.whatsThisButton.superview?.layoutIfNeeded()
        })
    }
    func hideWhatsThisButton() {
        UIView.animate(withDuration: 0.3*0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.whatsThisButton.alpha = 0.0
            self.whatsThisButton.superview?.layoutIfNeeded()
        })
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if var signUpInfoProvider = segue.destination as? SignUpInfoProvider {
            signUpInfoProvider.signUpInfo = signUpDict
        }
    }
    // MARK: - Google SignIn Delegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        SVProgressHUD.dismiss()
        if error == nil {
            let dataDict = SocialAuthManager.sharedInstance.convertGoogleUserToAppDict(user: user)
            self.signUpDict = self.signUpDict!.merging(dataDict) { (_, new) in new }
            if let email = self.signUpDict![User.CodingKeys.email.stringValue] as? String {
                self.verifyEmailFromServer(email: email)
            }
//            self.performSegue(withIdentifier: "toSignUpPersonalInfo", sender: self)
        } else {
            if error.localizedDescription != "The user canceled the sign-in flow." {
                UtilityManager.showErrorMessage(body: error.localizedDescription, in: self)
            }
        }
    }
    // MARK: - Actions

    @IBAction func facebookBtnTapped(_ sender: Any) {
        SVProgressHUD.show()
        SocialAuthManager.sharedInstance.loginWithFacebook(from: self) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            if isSuccess {
                let resp = response as! [String: Any]
                self.signUpDict = self.signUpDict!.merging(resp) { (_, new) in new }
                if let email = self.signUpDict![User.CodingKeys.email.stringValue] as? String {
                    self.verifyEmailFromServer(email: email)
                }
//                self.performSegue(withIdentifier: "toSignUpPersonalInfo", sender: self)
            } else {
                let err = response as! Error
                if err.localizedDescription != "Token is empty." {
                    UtilityManager.showErrorMessage(body: err.localizedDescription, in: self)
                }
            }
        }
    }
    @IBAction func whatsThisButtonTapped(_ sender: Any) {
        referralCodeTextField.resignFirstResponder()
        let popUpInstnc = ReferralPopupVC.instance()
        let popUpVC = PopupController
            .create(self)
            .show(popUpInstnc)
        popUpInstnc.closeHandler = { []  in
            popUpVC.dismiss()
        }
    }
    @IBAction func pasteButtonTapped(_ sender: Any) {
        let pasteBoard: UIPasteboard = UIPasteboard.general
        referralCodeTextField.text = pasteBoard.string
        if referralCodeTextField.text != "" {
            showWhatsThisButton()
        }
    }
    @IBAction func googleBtnTapped(_ sender: Any) {
        SVProgressHUD.show()
        GIDSignIn.sharedInstance()?.signOut()
        GIDSignIn.sharedInstance()?.signIn()
    }

    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func signUpBtnTapped(_ sender: Any) {
        validator.validate(self)

    }

    @IBAction func showPasswordBtnTapped(_ sender: Any) {
        if passwordTxtFld.isSecureTextEntry {
            passwordTxtFld.isSecureTextEntry = false
            (sender as AnyObject).setImage(UIImage(named: "eyeIconHide"), for: .normal)
        } else {
            passwordTxtFld.isSecureTextEntry = true
            (sender as AnyObject).setImage(UIImage(named: "eye-icon-white"), for: .normal)
        }
    }

    @IBAction func signInButtoonTapped(_ sender: Any) {
    }
    @IBAction func showConfirmPasswordBtnTapped(_ sender: Any) {
        if confirmPasswordTxtFld.isSecureTextEntry {
            confirmPasswordTxtFld.isSecureTextEntry = false
            (sender as AnyObject).setImage(UIImage(named: "eyeIconHide"), for: .normal)
        } else {
            confirmPasswordTxtFld.isSecureTextEntry = true
            (sender as AnyObject).setImage(UIImage(named: "eye-icon-white"), for: .normal)
        }
    }
}

extension SignUpEmailVC: SignUpInfoProvider {
    var signUpInfo: [String: Any]? {
        get { return signUpDict }
        set (newInfo) {
            signUpDict = newInfo
        }
    }
}
extension SignUpEmailVC: ASAuthorizationControllerDelegate {
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Get user data with Apple ID credentitial
            let dataDict = SocialAuthManager.sharedInstance.convertAppleUserToAppDict(user: appleIDCredential)
            self.signUpDict = self.signUpDict!.merging(dataDict) { (_, new) in new }
            if let email = self.signUpDict![User.CodingKeys.email.stringValue] as? String {
                self.verifyEmailFromServer(email: email)
            }
            // Write your code here
        }
    }
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        UtilityManager.showErrorMessage(body: error.localizedDescription, in: self)
        print(error.localizedDescription)
    }
}

extension SignUpEmailVC: ASAuthorizationControllerPresentationContextProviding {
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
