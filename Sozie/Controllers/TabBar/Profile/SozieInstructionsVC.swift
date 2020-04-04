//
//  SozieInstructionsVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 3/26/20.
//  Copyright © 2020 Danial Zahid. All rights reserved.
//

import UIKit

class SozieInstructionsVC: UIViewController {

    @IBOutlet weak var instructionsImageView: UIImageView!
    @IBOutlet weak var instructionsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        instructionsHeightConstraint.constant = (875.0/375.0) * UIScreen.main.bounds.size.width
        if let gender = UserDefaultManager.getCurrentUserGender() {
            if gender == "M" {
                instructionsImageView.image = UIImage(named: "MaleInstructions")
                instructionsHeightConstraint.constant = (842.0/375.0) * UIScreen.main.bounds.size.width
            } else {
                instructionsImageView.image = UIImage(named: "instructions")
                instructionsHeightConstraint.constant = (875.0/375.0) * UIScreen.main.bounds.size.width
            }
        }
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
