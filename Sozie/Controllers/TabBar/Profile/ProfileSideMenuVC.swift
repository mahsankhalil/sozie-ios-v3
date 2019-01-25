//
//  ProfileSideMenuVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/25/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class ProfileSideMenuVC: UIViewController {

    @IBOutlet weak var logoutBtn: DZGradientButton!
    @IBOutlet weak var tblVu: UITableView!
    @IBOutlet weak var menuBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        logoutBtn.cornerRadius = 0.0
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func menuBtnTapped(_ sender: Any) {
    }
    @IBAction func logoutBtnTapped(_ sender: Any) {
    }
}
