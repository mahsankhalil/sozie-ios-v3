//
//  ResetPasswordVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/22/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import MaterialTextField
import SwiftValidator
class ResetPasswordVC: UIViewController , UITextFieldDelegate,ValidationDelegate {

    @IBOutlet weak var saveBtn: DZGradientButton!
    @IBOutlet weak var retypePasswordTxtFld: MFTextField!
    @IBOutlet weak var passwordTxtFld: MFTextField!
    @IBOutlet weak var backBtn: UIButton!
    
    let validator = Validator()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        passwordTxtFld.setupAppDesign()
        retypePasswordTxtFld.setupAppDesign()
        applyValidators()
    }
    
    func applyValidators() {
        
        validator.registerField(passwordTxtFld, errorLabel: nil, rules: [RequiredRule(message: "Password can't be empty") as Rule, MinLengthRule(length: 9) as Rule, MaxLengthRule(length: 20) as Rule])
        
        [passwordTxtFld].forEach { (field) in
            field?.delegate = self
        }
        
        
        
        
    }
    
    
    // MARK: - Validation CallBacks
    func validationSuccessful() {
        
        if passwordTxtFld.text != retypePasswordTxtFld.text
        {
            retypePasswordTxtFld.setError(CustomError(str: "Password and Retype password do not match"), animated: true)
        }
        else
        {
            
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
    @IBAction func saveBtnTapped(_ sender: Any) {
        validator.validate(self)
    }
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    
}
