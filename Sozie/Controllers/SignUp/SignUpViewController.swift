//
//  SignUpViewController.swift
//  Quicklic
//
//  Created by Danial Zahid on 25/08/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit
import SwiftValidator

class SignUpViewController: UIViewController {

  @IBOutlet weak var femaleBtn: UIButton!
  @IBOutlet weak var maleBtn: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()



      maleBtn.applyButtonUnSelected()
      femaleBtn.applyButtonUnSelected()

      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
