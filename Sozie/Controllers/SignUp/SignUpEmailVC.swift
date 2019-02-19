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

    var signUpDict : [String: Any]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        emailTxtFld.setupAppDesign()
        passwordTxtFld.setupAppDesign()
        confirmPasswordTxtFld.setupAppDesign()

        applyValidators()
    }
    
    //MARK: - Custom Methods
    func applyValidators() {
        validator.registerField(emailTxtFld, errorLabel: nil, rules: [RequiredRule(message: "Email can't be empty") as Rule,EmailRule(message: "Invalid email")])
        validator.registerField(passwordTxtFld, errorLabel: nil, rules: [RequiredRule(message: "Password can't be empty") as Rule, MinLengthRule(length: 9) as Rule, MaxLengthRule(length: 20) as Rule])
        
        [emailTxtFld, passwordTxtFld].forEach { (field) in
            field?.delegate = self
        }
    }
    
    func verifyEmailFromServer(email : String?) {
        let dataDict = ["attr_type" : "email" , "attr_value" : email!]
        SVProgressHUD.show()
        ServerManager.sharedInstance.validateEmailOrUsername(params: dataDict as [String : Any]) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            if isSuccess {
                self.performSegue(withIdentifier: "toSignUpPersonalInfo", sender: self)
                
            } else {
                let error = response as! Error
                UtilityManager.showMessageWith(title: "Please Try Again", body: error.localizedDescription, in: self)
            }
        }
    }
    
    // MARK: - Validation CallBacks
    func validationSuccessful() {
        if passwordTxtFld.text != confirmPasswordTxtFld.text {
            confirmPasswordTxtFld.setError(CustomError(str: "Password and Confirm do not match"), animated: true)
        } else {
            signUpDict![User.CodingKeys.email.stringValue] = emailTxtFld.text
            signUpDict!["password"] = passwordTxtFld.text

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
    
    //MARK: - Text Field Delegates
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let txtFld  = textField as! MFTextField
        txtFld.setError(nil, animated: true)
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
    
    // MARK: Google SignIn Delegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        SVProgressHUD.dismiss()
        if error == nil {
            let dataDict = SocialAuthManager.sharedInstance.convertGoogleUserToAppDict(user: user)
            self.signUpDict = self.signUpDict!.merging(dataDict) { (_, new) in new }
            self.performSegue(withIdentifier: "toSignUpPersonalInfo", sender: self)
        } else {
            UtilityManager.showErrorMessage(body: error.localizedDescription, in: self)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func facebookBtnTapped(_ sender: Any) {
        SVProgressHUD.show()
        SocialAuthManager.sharedInstance.loginWithFacebook(from: self) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            if isSuccess {
                let resp = response as! [String : Any]
                self.signUpDict = self.signUpDict!.merging(resp) { (_, new) in new }
                self.performSegue(withIdentifier: "toSignUpPersonalInfo", sender: self)
            } else {
                let err = response as! Error
                UtilityManager.showErrorMessage(body: err.localizedDescription, in: self)
            }
        }
    }
    
    @IBAction func googleBtnTapped(_ sender: Any) {
        SVProgressHUD.show()
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
