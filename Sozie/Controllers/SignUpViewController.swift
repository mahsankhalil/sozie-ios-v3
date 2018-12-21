//
//  SignUpViewController.swift
//  Quicklic
//
//  Created by Danial Zahid on 25/08/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit
import SwiftValidator

class SignUpViewController: UIViewController, ValidationDelegate, UITextFieldDelegate {

  @IBOutlet weak var femaleBtn: UIButton!
  @IBOutlet weak var maleBtn: UIButton!
  @IBOutlet weak var emailField: DesignableTextField!
    @IBOutlet weak var nameField: DesignableTextField!
    @IBOutlet weak var passwordField: DesignableTextField!
    @IBOutlet weak var confirmPasswordField: DesignableTextField!
    @IBOutlet weak var errorLabel: UILabel!
    let validator = Validator()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        validator.registerField(emailField, errorLabel: errorLabel, rules: [RequiredRule(message: "Email can't be empty") as Rule,EmailRule(message: "Invalid email")])
//        validator.registerField(nameField, errorLabel: errorLabel, rules: [RequiredRule(message: "Name can't be empty") as Rule, MinLengthRule(length: 3) as Rule])
//        validator.registerField(passwordField, errorLabel: errorLabel, rules: [RequiredRule(message: "Password can't be empty") as Rule, MinLengthRule(length: 8) as Rule, MaxLengthRule(length: 20) as Rule, PasswordRule() as Rule])
//        validator.registerField(confirmPasswordField, errorLabel: errorLabel, rules: [ConfirmationRule(confirmField: passwordField)])
//
//        [emailField,nameField,passwordField,confirmPasswordField].forEach { (field) in
//            field?.delegate = self
//        }
      
      maleBtn.layer.borderColor = UIColor(displayP3Red: 166.0/255.0, green: 166.0/255.0, blue: 166.0/255.0, alpha: 0.8).cgColor
      maleBtn.layer.cornerRadius = 2.0
      maleBtn.layer.borderWidth = 1.0
      maleBtn.clipsToBounds = true
      
      femaleBtn.layer.borderColor = UIColor(displayP3Red: 166.0/255.0, green: 166.0/255.0, blue: 166.0/255.0, alpha: 0.8).cgColor
      femaleBtn.layer.cornerRadius = 2.0
      femaleBtn.layer.borderWidth = 1.0

      femaleBtn.clipsToBounds = true
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        validator.validate(self)
    }
    
    func validationSuccessful() {
        var params = [String:String]()
        params["email"] = emailField.text
        params["full_name"] = nameField.text
        params["password"] = passwordField.text
        
        
        emailField.resignFirstResponder()
        nameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        confirmPasswordField.resignFirstResponder()
        
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        for (field, error) in errors {
            if let field = field as? UITextField {
                field.layer.borderColor = UIColor.red.cgColor
                field.layer.borderWidth = 1.0
                if error.errorLabel?.isHidden == true {
                    error.errorLabel?.text = error.errorMessage // works if you added labels
                    error.errorLabel?.isHidden = false
                }
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.white.cgColor
        errorLabel.isHidden = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " && textField == emailField {
            return false
        }
        return true
    }
  
  
  @IBAction func femaleBtnTapped(_ sender: Any) {
    maleBtn.layer.borderColor = UIColor(displayP3Red: 166.0/255.0, green: 166.0/255.0, blue: 166.0/255.0, alpha: 0.8).cgColor
    maleBtn.layer.cornerRadius = 2.0
    maleBtn.layer.borderWidth = 1.0

    maleBtn.clipsToBounds = true
    
    femaleBtn.layer.borderColor = UIColor(displayP3Red: 252.0/255.0, green: 135.0/255.0, blue: 135.0/255.0, alpha: 0.8).cgColor
    femaleBtn.layer.cornerRadius = 2.0
    femaleBtn.layer.borderWidth = 1.0

    femaleBtn.clipsToBounds = true
    
  
  }
  
  @IBAction func maleBtnTapped(_ sender: Any) {
    maleBtn.layer.borderColor = UIColor(displayP3Red: 252.0/255.0, green: 135.0/255.0, blue: 135.0/255.0, alpha: 0.8).cgColor
    maleBtn.layer.cornerRadius = 2.0
    maleBtn.layer.borderWidth = 1.0

    maleBtn.clipsToBounds = true
    
    femaleBtn.layer.borderColor = UIColor(displayP3Red: 166.0/255.0, green: 166.0/255.0, blue: 166.0/255.0, alpha: 0.8).cgColor
    femaleBtn.layer.cornerRadius = 2.0
    femaleBtn.layer.borderWidth = 1.0
    femaleBtn.clipsToBounds = true
  }
  @IBAction func backBtnTapped(_ sender: Any) {
    self.dismiss(animated: true) {
      
    }
  }
  
}
