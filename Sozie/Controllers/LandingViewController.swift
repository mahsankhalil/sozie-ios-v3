//
//  LandingViewController.swift
//  Sozie
//
//  Created by Danial Zahid on 17/12/2018.
//  Copyright © 2018 Danial Zahid. All rights reserved.
//

import UIKit

public enum UserType: String {
    case sozie = "SZ"
    case shopper = "SP"
}

class LandingViewController: UIViewController {

    var currentUserType: UserType?
    var signUpDict: [String: Any] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if var signUpInfoProvider = segue.destination as? SignUpInfoProvider {
            signUpInfoProvider.signUpInfo = signUpDict
        }
//        if segue.identifier == "toCountryVC", let selectCountryViewController = segue.destination as? SelectCountryVC {
//            selectCountryViewController.currentUserType = currentUserType
//        }
    }

    @IBAction func signupShopperBtnTapped(_ sender: Any) {
        currentUserType = .shopper
        signUpDict[User.CodingKeys.country.stringValue] = 2
        signUpDict[User.CodingKeys.type.stringValue] = currentUserType?.rawValue
        performSegue(withIdentifier: "toSignUpEmailVC", sender: self)
//        performSegue(withIdentifier: "toCountryVC", sender: self)
    }

    @IBAction func signUpSozieBtnTapped(_ sender: Any) {
        currentUserType = .sozie
        signUpDict[User.CodingKeys.country.stringValue] = 2
        signUpDict[User.CodingKeys.type.stringValue] = currentUserType?.rawValue
        performSegue(withIdentifier: "toWorkVC", sender: self)

//        performSegue(withIdentifier: "toCountryVC", sender: self)
    }

}
