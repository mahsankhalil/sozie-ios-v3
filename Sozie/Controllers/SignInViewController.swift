//
//  SignInViewController.swift
//  Sozie
//
//  Created by Danial Zahid on 16/12/2018.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit
import SwiftValidator
import UnderLineTextField
import GoogleSignIn
import UnderLineTextField
import SVProgressHUD
import FBSDKLoginKit

class SignInViewController: UIViewController, ValidationDelegate, UITextFieldDelegate, GIDSignInDelegate, GIDSignInUIDelegate, UnderLineTextFieldDelegate {
    
    static let identifier = "signInViewController"

    @IBOutlet weak var emailField: UnderLineTextField!
    @IBOutlet weak var passwordField: UnderLineTextField!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    
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
        
        emailField.validationType = .afterEdit
        passwordField.validationType = .afterEdit
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Field Validation
    func applyValidators() {
        validator.registerField(emailField, errorLabel: nil, rules: [RequiredRule(message: "Email can't be empty") as Rule,EmailRule(message: "Invalid email")])
        validator.registerField(passwordField, errorLabel: nil, rules: [RequiredRule(message: "Password can't be empty") as Rule, MinLengthRule(length: 8) as Rule, MaxLengthRule(length: 20) as Rule])
        
        [emailField, passwordField].forEach { (field) in
            field?.delegate = self
        }
        
    
        
        
    }
    
    func validationSuccessful() {
        
        var params = [String : String]()
        params["email"] = emailField.text
        params["password"] = passwordField.text
        
        SVProgressHUD.show()
        
        
        ServerManager.sharedInstance.loginWith(params: params) { (isSuccess, response) in
            SVProgressHUD.dismiss()

        }
        
//        RequestManager.loginUser(param: params, successBlock: { (response) in
//            SVProgressHUD.dismiss()
//            self.successfulLogin(response: response)
//        }) { (error) in
//
//            UtilityManager.showErrorMessage(body: error, in: self)
//        }
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        for (field, error) in errors {
            if let field = field as? UnderLineTextField {

                _ = field.resignFirstResponder()
                field.errorLabel.text = error.errorMessage
                field.status = .error
//                }
            }
        }
    }
    
    func textFieldValidate(underLineTextField: UnderLineTextField) throws {
        if underLineTextField.status == .error
        {
            throw UnderLineTextFieldErrors.error(message: "Invalid data")

        }

        
    }
    
    //MARK: - IBActions
    @IBAction func signinButtonPressed(_ sender: Any) {
        validator.validate(self)
    }
    
    @IBAction func facebookButtonPressed(sender: AnyObject) {
        let loginManager = FBSDKLoginManager()
        loginManager.loginBehavior = FBSDKLoginBehavior.native
        loginManager.logIn(withReadPermissions: ["public_profile","email"], from: self) { (result, error) in
            SVProgressHUD.show()
            guard let token = result?.token else {
                SVProgressHUD.dismiss()
                return
            }
            // Verify token is not empty
            if token.tokenString.isEmpty {
                print("Token is empty")
                SVProgressHUD.dismiss()
                return
            }
            // Request Fields
            let fields = "name,first_name,last_name,email,gender,picture,locale,link"
            
            // Build URL with Access Token
            let url = Constant.facebookURL + "?fields=\(fields)&access_token=\(token.tokenString!)"
            
            //Make API call to facebook graph api to get data
//            RequestManager.getUserFacebookProfile(url: url, successBlock: { (response) in
//                /*{
//                 email = "danialzahid94@live.com";
//                 "first_name" = Danial;
//                 gender = male;
//                 id = 10210243338655397;
//                 "last_name" = Zahid;
//                 name = "Danial Zahid";
//                 }*/
//                print(response)
//                var params = [String: String]()
//                params["social_provider_name"] = "facebook"
//                params["full_name"] = response["name"] as? String
//                params["social_id"] = response["id"] as? String
//                params["email"] = response["email"] as? String
//                params["facebook_profile"] = response["link"] as? String
//                if let image = response["picture"] as? [String: AnyObject] {
//                    if let data = image["data"] as? [String: AnyObject] {
//                        params["image_path"] = data["url"] as? String
//                    }
//                }
//
//
//                RequestManager.socialLoginUser(param: params, successBlock: { (response) in
//                    self.successfulLogin(response: response)
//                }, failureBlock: { (error) in
//
//                    UtilityManager.showErrorMessage(body: error, in: self)
//
//                })
//
//            }, failureBlock: { (error) in
//                UtilityManager.showErrorMessage(body: error, in: self)
//            })
        }
    }
    
    @IBAction func googleButtonPressed(sender: AnyObject) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            // Perform any operations on signed in user here.
            var params = [String: String]()
            
            params["social_provider_name"] = "google"
            params["full_name"] = user.profile.name
            params["social_id"] = user.userID
            params["email"] = user.profile.email
            params["image_path"] = user.profile.imageURL(withDimension: 200).absoluteString
            
            
//            RequestManager.socialLoginUser(param: params, successBlock: { (response) in
//                self.successfulLogin(response: response)
//            }, failureBlock: { (error) in
//                UtilityManager.showErrorMessage(body: error, in: self)
//                
//            })
            // ...
        } else {
            if error.localizedDescription == "The user canceled the sign-in flow." {
                return
            }
            UtilityManager.showErrorMessage(body: error.localizedDescription, in: self)
        }
    }
    
    func sign(didDisconnectWithUser user: GIDGoogleUser,
                withError error: Error) {
        // Perform any operations when the user disconnects from app here.
        // ...
        SVProgressHUD.dismiss()
    }
    
    //MARK: Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " && textField == emailField {
            return false
        }
        return true
    }
    
    //MARK: - 
    func showAlertView(title: String, message: String) {
        SVProgressHUD.dismiss()
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func successfulLogin(response: [String: AnyObject]) {
        SVProgressHUD.dismiss()
//        let user = User(dictionary: response)
//        ApplicationManager.sharedInstance.user = user
//        ApplicationManager.sharedInstance.session_id = response["session_id"] as! String
//        UserDefaults.standard.set(response["session_id"] as! String, forKey: UserDefaultKey.sessionID)
        //        Router.showMainTabBar()
    }
    
    
}
