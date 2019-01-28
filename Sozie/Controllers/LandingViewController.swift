//
//  LandingViewController.swift
//  Sozie
//
//  Created by Danial Zahid on 17/12/2018.
//  Copyright © 2018 Danial Zahid. All rights reserved.
//

import UIKit
public enum UserType : String {
    case sozie = "Sozie"
    case shopper = "Shopper"
}
class LandingViewController: UIViewController {

    var currentUserType: UserType?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toCountryVC" {
            let vc = segue.destination as! SelectCountryVC
            vc.currentUserType = currentUserType
        }
    }
    
    @IBAction func signupShopperBtnTapped(_ sender: Any) {
        currentUserType = .shopper
        performSegue(withIdentifier: "toCountryVC", sender: self)
    }
    
    @IBAction func signUpSozieBtnTapped(_ sender: Any) {
        currentUserType = .sozie
        performSegue(withIdentifier: "toCountryVC", sender: self)
    }

}
