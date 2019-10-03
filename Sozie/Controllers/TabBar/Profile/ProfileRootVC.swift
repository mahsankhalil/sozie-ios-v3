//
//  ProfileVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/25/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import SideMenu
class ProfileRootVC: BaseViewController {
    var tabViewController: ProfileTabsPageVC?
    @IBOutlet weak var tabView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var waistLabel: UILabel!
    @IBOutlet weak var hipLabel: UILabel!
    @IBOutlet weak var braLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tabViewController = ProfileTabsPageVC()
        tabViewController?.view.backgroundColor = UIColor.clear
        tabView.addSubview((tabViewController?.view)!)
        tabView.autoresizesSubviews = true
        tabViewController?.view.frame = CGRect(x: 0.0, y: 0.0, width: tabView.frame.size.width, height: tabView.frame.size.height)
        self.addChild(tabViewController!)
        setupProfileNavBar()
        SideMenuManager.default.menuRightNavigationController = storyboard!.instantiateViewController(withIdentifier: "RightMenuNavigationController") as? UISideMenuNavigationController
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuWidth = UIScreen.main.bounds.size.width - 60.0
        SideMenuManager.default.menuAnimationFadeStrength = 0.5
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2.0
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.borderColor = UIColor(hex: "A6A6A6").cgColor
        profileImageView.clipsToBounds = true
        populateCurrentUserData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        populateCurrentUserData()
        if let userId = UserDefaultManager.getCurrentUserId() {
            ServerManager.sharedInstance.getUserProfile(userId: userId) { (isSuccess, response) in
                if isSuccess {
                    let user = response as! User
                    UserDefaultManager.updateUserObject(user: user)
                }
            }
        }
    }
    func populateCurrentUserData() {
        if let currentUser = UserDefaultManager.getCurrentUserObject() {
            self.nameLabel.text = currentUser.username
            if let measurement = currentUser.measurement {
                if let bra = measurement.bra, let cup = measurement.cup {
                    braLabel.text = "Bra Size: " + String(bra) + cup
                }
                if let unit = measurement.unit {
                    if unit == "IN" {
                        if let height = measurement.height {
                            let heightMeasurment = NSMeasurement(doubleValue: Double(height), unit: UnitLength.inches)
                            let feetMeasurement = heightMeasurment.converting(to: UnitLength.feet)
                            heightLabel.text = "Height: " + feetMeasurement.value.feetToFeetInches() + "  |"
                        }
                    } else {
                        if let height = measurement.height {
                            heightLabel.text = "Height: " + String(height) + "  |"
                        }
                    }
                } else {
                    if let height = measurement.height {
                        let heightMeasurment = NSMeasurement(doubleValue: Double(height), unit: UnitLength.inches)
                        let feetMeasurement = heightMeasurment.converting(to: UnitLength.feet)
                        heightLabel.text = "Height: " + feetMeasurement.value.feetToFeetInches() + "  |"
                    }

                }
                
                if let hip = measurement.hip {
                    hipLabel.text = "Hip: " + String(hip) + "  |"
                }
                if let waist = measurement.waist {
                    waistLabel.text = "Waist: " + String(waist) + "  |"
                }
            }
            if let imageURL = currentUser.picture {
                if imageURL != "" {
                    profileImageView.sd_setImage(with: URL(string: imageURL), completed: nil)
                }
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

}
