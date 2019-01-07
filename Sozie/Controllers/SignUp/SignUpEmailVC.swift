//
//  SignUpEmailVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/3/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import MaterialTextField

class SignUpEmailVC: UIViewController {

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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        

        emailTxtFld.setupAppDesign()
        passwordTxtFld.setupAppDesign()
        confirmPasswordTxtFld.setupAppDesign()




    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    
    @IBAction func signInBtnTapped(_ sender: Any) {
    }
    @IBAction func showPasswordBtnTapped(_ sender: Any) {
        self.passwordTxtFld.isSecureTextEntry = !self.passwordTxtFld.isSecureTextEntry
        
    }
    @IBAction func showConfirmPasswordBtnTapped(_ sender: Any) {
        self.confirmPasswordTxtFld.isSecureTextEntry = !self.confirmPasswordTxtFld.isSecureTextEntry

    }
}
