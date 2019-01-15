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
class SignUpEmailVC: UIViewController , UITextFieldDelegate, ValidationDelegate{

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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        

        emailTxtFld.setupAppDesign()
        passwordTxtFld.setupAppDesign()
        confirmPasswordTxtFld.setupAppDesign()

        applyValidators()
    }
    
    //MARK: - Custom Methods
    func applyValidators() {
        validator.registerField(emailTxtFld, errorLabel: nil, rules: [RequiredRule(message: "Email can't be empty") as Rule,EmailRule(message: "Invalid email")])
        validator.registerField(passwordTxtFld, errorLabel: nil, rules: [RequiredRule(message: "Password can't be empty") as Rule, MinLengthRule(length: 8) as Rule, MaxLengthRule(length: 20) as Rule])
        
        [emailTxtFld, passwordTxtFld].forEach { (field) in
            field?.delegate = self
        }
        
        
        
        
    }
    
    func validationSuccessful() {
        
        if passwordTxtFld.text != confirmPasswordTxtFld.text
        {
            confirmPasswordTxtFld.setError(CustomError(str: "Password and Confirm do not match"), animated: true)
        }
        else
        {
            var params = [String : String]()
            params["email"] = emailTxtFld.text
            params["password"] = passwordTxtFld.text
            
            confirmPasswordTxtFld.setError( nil, animated: true)
            performSegue(withIdentifier: "toSignUpPersonalInfo", sender: self)

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Actions
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    
    @IBAction func signUpBtnTapped(_ sender: Any) {
        validator.validate(self)

    }
    @IBAction func showPasswordBtnTapped(_ sender: Any) {
        self.passwordTxtFld.isSecureTextEntry = !self.passwordTxtFld.isSecureTextEntry
        
    }
    @IBAction func showConfirmPasswordBtnTapped(_ sender: Any) {
        self.confirmPasswordTxtFld.isSecureTextEntry = !self.confirmPasswordTxtFld.isSecureTextEntry

    }
}
