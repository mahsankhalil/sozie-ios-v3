//
//  ChangePasswordVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 3/11/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import MaterialTextField
import SwiftValidator
import SVProgressHUD

class ChangePasswordVC: UIViewController, UITextFieldDelegate, ValidationDelegate {
    @IBOutlet weak var saveBtn: DZGradientButton!
    @IBOutlet weak var retypePasswordTxtFld: MFTextField!
    @IBOutlet weak var passwordTxtFld: MFTextField!
    @IBOutlet weak var currentPasswordTxtFld: MFTextField!
    @IBOutlet weak var backBtn: UIButton!
    let validator = Validator()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        passwordTxtFld.setupAppDesign()
        retypePasswordTxtFld.setupAppDesign()
        currentPasswordTxtFld.setupAppDesign()
        applyValidators()
        applyRightVuToPassword(passwordField: currentPasswordTxtFld)
        applyRightVuToPassword(passwordField: passwordTxtFld)
        applyRightVuToPassword(passwordField: retypePasswordTxtFld)
    }
    func applyRightVuToPassword(passwordField: MFTextField) {
        let eyeBtn = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 19.0, height: 22.0))
        eyeBtn.setImage(UIImage(named: "eye-icon-white"), for: .normal)
        eyeBtn.tag = passwordField.tag
        eyeBtn.addTarget(self, action: #selector(eyeBtnTapped(sender:)), for: .touchUpInside)
        passwordField.rightViewMode = .always
        passwordField.rightView = eyeBtn
    }
    @objc func eyeBtnTapped(sender: UIButton) {
        var txtField: MFTextField?
        if sender.tag == 0 {
            txtField = currentPasswordTxtFld
        } else if sender.tag == 1 {
            txtField = passwordTxtFld
        } else {
            txtField = retypePasswordTxtFld
        }
        if txtField!.isSecureTextEntry {
            txtField!.isSecureTextEntry = false
            sender.setImage(UIImage(named: "eyeIconHide"), for: .normal)
        } else {
            txtField!.isSecureTextEntry = true
            sender.setImage(UIImage(named: "eye-icon-white"), for: .normal)
        }
    }
    func applyValidators() {
        validator.registerField(passwordTxtFld, errorLabel: nil, rules: [RequiredRule(message: "Password can't be empty") as Rule, MinLengthRule(length: 9) as Rule, MaxLengthRule(length: 20) as Rule])
        validator.registerField(currentPasswordTxtFld, errorLabel: nil, rules: [RequiredRule(message: "Password can't be empty") as Rule])

        [passwordTxtFld, currentPasswordTxtFld, retypePasswordTxtFld].forEach { (field) in
            field?.delegate = self
        }
    }
    func validationSuccessful() {
        if passwordTxtFld.text != retypePasswordTxtFld.text {
            retypePasswordTxtFld.setError(CustomError(str: "Password and Retype password do not match"), animated: true)
        } else {
            var params = [String: Any]()
            params["new_password"] = self.passwordTxtFld.text
            params["old_password"] = self.currentPasswordTxtFld.text
            SVProgressHUD.show()
            ServerManager.sharedInstance.changePassword(params: params) { (isSuccess, response) in
                SVProgressHUD.dismiss()
                if isSuccess {
                    let resp = response as! ValidateRespose
                    UtilityManager.showMessageWith(title: "Success!", body: resp.detail, in: self, block: {
                        self.dismiss(animated: true, completion: nil)
                    })
                } else {
                    let err = response as! Error
                    UtilityManager.showErrorMessage(body: err.localizedDescription, in: self)
                }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: - Text Field Delegates
    func textFieldDidEndEditing(_ textField: UITextField) {
        let txtFld  = textField as! MFTextField
        txtFld.setError(nil, animated: true)
    }
    @IBAction func saveBtnTapped(_ sender: Any) {
        validator.validate(self)
    }
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
