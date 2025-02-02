//
//  SignInViewController.swift
//  Sozie
//
//  Created by Danial Zahid on 16/12/2018.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit
import SwiftValidator
import GoogleSignIn
import SVProgressHUD
import MaterialTextField
import FBSDKLoginKit
import TPKeyboardAvoiding
import AuthenticationServices
class SignInViewController: UIViewController, ValidationDelegate, UITextFieldDelegate, GIDSignInDelegate, GIDSignInUIDelegate {

    static let identifier = "signInViewController"
    @IBOutlet weak var emailField: MFTextField!
    @IBOutlet weak var passwordField: MFTextField!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var appleLoginButtonView: UIView!
    @IBOutlet weak var socialButtonViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginAppleButtonWidthConstraint: NSLayoutConstraint!
    let validator = Validator()
    override func viewDidLoad() {
        super.viewDidLoad()
        applyValidators()
        facebookLoginButton.layer.cornerRadius = facebookLoginButton.frame.height/2
        facebookLoginButton.layer.masksToBounds = true
        facebookLoginButton.isExclusiveTouch = true
        googleButton.isExclusiveTouch = true
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        emailField.setupAppDesign()
        passwordField.setupAppDesign()
        applyRightVuToPassword()
        setupAppleLoginButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
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
    func applyRightVuToPassword() {
        let eyeBtn = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 19.0, height: 22.0))
        eyeBtn.setImage(UIImage(named: "eye-icon-white"), for: .normal)
        eyeBtn.addTarget(self, action: #selector(eyeBtnTapped(sender:)), for: .touchUpInside)
        passwordField.rightViewMode = .always
        passwordField.rightView = eyeBtn
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Field Validation
    func applyValidators() {
        validator.registerField(emailField, errorLabel: nil, rules: [RequiredRule(message: "Email can't be empty") as Rule, EmailRule(message: "Invalid email")])
        validator.registerField(passwordField, errorLabel: nil, rules: [RequiredRule(message: "Password can't be empty") as Rule, MinLengthRule(length: 8) as Rule, MaxLengthRule(length: 20) as Rule])
        [emailField, passwordField].forEach { (field) in
            field?.delegate = self
        }
    }

    func validationSuccessful() {
        var params = [String: String]()
        params["email"] = emailField.text
        params["password"] = passwordField.text
        signInWithDict(dataDict: params)
    }

    func signInWithDict(dataDict: [String: Any]) {
        SVProgressHUD.show()
        ServerManager.sharedInstance.loginWith(params: dataDict) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            if isSuccess {
                // Do something after login
                let res = response as! LoginResponse
                _ = UserDefaultManager.saveLoginResponse(loginResp: res)
//                UtilityManager.registerUserOnIntercom()
                if let user = UserDefaultManager.getCurrentUserObject() {
                    SegmentManager.createEntity(user: user)
                    if let tutorialCompleted = user.tutorialCompleted {
                        if tutorialCompleted == false {
                            UserDefaultManager.removeAllUserGuidesShown()
                        } else {
                            UserDefaultManager.setPostTutorialShown()
                            UserDefaultManager.setBrowserTutorialShown()
                            UserDefaultManager.setRequestTutorialShown()
                        }
                    }
                }
                self.changeRootVCToTabBarNC()
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.updatePushTokenToServer()
            } else {
                let error = response as! Error
                UtilityManager.showMessageWith(title: "Please Try Again", body: error.localizedDescription, in: self)
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
    func textFieldDidEndEditing(_ textField: UITextField) {
        let txtFld  = textField as! MFTextField
        txtFld.setError(nil, animated: true)
    }
    // MARK: - IBActions
    @IBAction func signinButtonPressed(_ sender: Any) {
        validator.validate(self)
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func signUpButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func facebookButtonPressed(sender: AnyObject) {
        SVProgressHUD.show()
        SocialAuthManager.sharedInstance.loginWithFacebook(from: self) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            if isSuccess {
                let resp = response as! [String: Any]
                self.signInWithDict(dataDict: resp)
            } else {
                let err = response as! Error
                if err.localizedDescription != "Token is empty." {
                    UtilityManager.showErrorMessage(body: err.localizedDescription, in: self)
                }
            }
        }
    }

    @IBAction func googleButtonPressed(sender: AnyObject) {
        GIDSignIn.sharedInstance()?.signOut()
        GIDSignIn.sharedInstance()?.signIn()
    }

    @objc func eyeBtnTapped(sender: UIButton) {
        if passwordField.isSecureTextEntry {
            passwordField.isSecureTextEntry = false
            sender.setImage(UIImage(named: "eyeIconHide"), for: .normal)
        } else {
            passwordField.isSecureTextEntry = true
            sender.setImage(UIImage(named: "eye-icon-white"), for: .normal)
        }
    }

    @IBAction func forgotPasswordBtnTapped(_ sender: Any) {
        let popUpInstnc = ForgotPasswordEmailPopUp.instance()
        let popUpVC = PopupController
            .create(self)
            .show(popUpInstnc)
            .customize([.movesAlongWithKeyboard(true)])
        popUpInstnc.closeHandler = { []  in
            popUpVC.dismiss()
        }
        popUpInstnc.delegate = self
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        SVProgressHUD.dismiss()
        if error == nil {
            let dataDict = SocialAuthManager.sharedInstance.convertGoogleUserToAppDict(user: user)
            self.signInWithDict(dataDict: dataDict)
        } else {
            if error.localizedDescription != "The user canceled the sign-in flow." {
                UtilityManager.showErrorMessage(body: error.localizedDescription, in: self)
            }
        }
    }

    func sign(didDisconnectWithUser user: GIDGoogleUser, withError error: Error) {
        // Perform any operations when the user disconnects from app here.
        // ...
        SVProgressHUD.dismiss()
    }
    // MARK: - Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " && textField == emailField {
            return false
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func showAlertView(title: String, message: String) {
        SVProgressHUD.dismiss()
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func successfulLogin(response: [String: AnyObject]) {
        SVProgressHUD.dismiss()
    }

    func forgotPassword(email: String) {
        let dataDict = ["email": email]
        SVProgressHUD.show()
        ServerManager.sharedInstance.forgotPasswordWith(params: dataDict) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            if isSuccess {
                let resp = response as! ValidateRespose
                self.showPopUpWithResponse(isSuccess: isSuccess, detailStr: resp.detail)
            } else {
                let err = response as! Error
                self.showPopUpWithResponse(isSuccess: isSuccess, detailStr: err.localizedDescription)
            }
        }
    }

    func showPopUpWithResponse(isSuccess: Bool, detailStr: String) {
        var popUpInstnc: ServerResponsePopUp?
        if isSuccess {
            popUpInstnc = ServerResponsePopUp.instance(imageName: "checked", title: "Email Sent", description: detailStr)

        } else {
            popUpInstnc = ServerResponsePopUp.instance(imageName: "cancel", title: "Email Not Sent", description: detailStr)
        }
        let popUpVC = PopupController
            .create(self)
            .show(popUpInstnc!)
        popUpInstnc!.closeHandler = { []  in
            popUpVC.dismiss()
        }
    }
}

extension SignInViewController: ForgotPasswordEmailPopupDelegate {
    func recoverPasswordBtnTapped(email: String) {
        self.forgotPassword(email: email)
    }
}
extension SignInViewController: ASAuthorizationControllerDelegate {
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Get user data with Apple ID credentitial
            let dataDict = SocialAuthManager.sharedInstance.convertAppleUserToAppDict(user: appleIDCredential)
            self.signInWithDict(dataDict: dataDict)
            // Write your code here
        }
    }
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
}

extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
