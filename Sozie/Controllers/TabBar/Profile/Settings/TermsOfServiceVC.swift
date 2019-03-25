//
//  TermsOfServiceVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 3/7/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
public enum TOSType: String {
    case privacyPolicy = "Privacy Policy"
    case termsCondition = "Terms and Conditions"
}
class TermsOfServiceVC: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    var type: TOSType?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let currentType = type {
            titleLabel.text = currentType.rawValue
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
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
