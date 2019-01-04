//
//  SignUpViewController.swift
//  Quicklic
//
//  Created by Danial Zahid on 25/08/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit
import SwiftValidator
import UnderLineTextField

class SignUpViewController: UIViewController {

  @IBOutlet weak var femaleBtn: UIButton!
  @IBOutlet weak var maleBtn: UIButton!

    @IBOutlet weak var lastNameTxtFld: UnderLineTextField!
    @IBOutlet weak var firstNameTxtFld: UnderLineTextField!
    @IBOutlet weak var userNameTxtFld: UnderLineTextField!
    @IBOutlet weak var dateOfBirtTxtFld: DatePickerTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()



        maleBtn.applyButtonUnSelected()
        femaleBtn.applyButtonUnSelected()
        
        dateOfBirtTxtFld.title = "DATE OF BIRTH"
        restrictToFourteenYears()
        
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func restrictToFourteenYears()
    {
        let fourteenYearInterval = TimeInterval(14 * 60 * 60 * 24 * 365)
        dateOfBirtTxtFld.pickerView.maximumDate = Date(timeIntervalSinceNow: fourteenYearInterval)
    }
    
    
    @IBAction func signupButtonPressed(_ sender: Any) {

  }
  
  
  
  @IBAction func femaleBtnTapped(_ sender: Any) {
    
    femaleBtn.applyButtonSelected()
    maleBtn.applyButtonUnSelected()
    femaleBtn.applyButtonShadow()
    
    maleBtn.layer.shadowOpacity = 0.0
    
  }
  
  @IBAction func maleBtnTapped(_ sender: Any) {
    
    maleBtn.applyButtonSelected()
    femaleBtn.applyButtonUnSelected()
    maleBtn.applyButtonShadow()    
    femaleBtn.layer.shadowOpacity = 0.0
  }
  @IBAction func backBtnTapped(_ sender: Any) {
    self.dismiss(animated: true) {
      
    }

  }
  
}
