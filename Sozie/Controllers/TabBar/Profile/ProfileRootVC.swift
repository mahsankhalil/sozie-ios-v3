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
    @IBOutlet weak var measurementView: UIStackView!
    @IBOutlet weak var addYourMeasurementsButton: UIButton!

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
        if UserDefaultManager.getIfPostTutorialShown() == false {
           self.addYourMeasurementsButton.isEnabled = false
        } else {
            self.addYourMeasurementsButton.isEnabled = true
        }
    }
    func populateCurrentUserData() {
        if let currentUser = UserDefaultManager.getCurrentUserObject() {
            self.nameLabel.text = currentUser.username
            populateMeasurementData(currentUser: currentUser)
            if let imageURL = currentUser.picture {
                if imageURL != "" {
                    profileImageView.sd_setImage(with: URL(string: imageURL), completed: nil)
                }
            }
        }
    }
    func populateMeasurementData(currentUser: User) {
        if UserDefaultManager.checkIfMeasurementEmpty() {
            measurementView.isHidden = true
            addYourMeasurementsButton.isHidden = false
        } else {
            measurementView.isHidden = false
            addYourMeasurementsButton.isHidden = true
        }
        if let measurement = currentUser.measurement {
            let gender = UserDefaultManager.getCurrentUserGender()
            if gender == "F" {
                if let bra = measurement.bra, let cup = measurement.cup {
                    braLabel.text = "Bra Size: " + String(bra) + cup
                }
            } else {
                if let chest = measurement.chest {
                    braLabel.text = "Chest: " + String(chest)
                }
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
    }

    @IBAction func addYourMeasurementsButtonTapped(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let measurementVC = storyBoard.instantiateViewController(withIdentifier: "MeasurementsVC") as! MeasurementsVC
        self.tabBarController?.navigationController?.pushViewController(measurementVC, animated: true)
    }
    @IBAction func sideMenuButtonTapped(_ sender: Any) {
        var sideMenuSet = SideMenuSettings()
        sideMenuSet.presentationStyle.backgroundColor = UIColor.black
        sideMenuSet.presentationStyle = .menuSlideIn
        sideMenuSet.menuWidth = UIScreen.main.bounds.size.width - 60.0
        sideMenuSet.statusBarEndAlpha = 0.0
        sideMenuSet.blurEffectStyle = .light
        sideMenuSet.presentationStyle.menuStartAlpha = 0.0
        sideMenuSet.presentationStyle.presentingEndAlpha = 0.3
        let rightMenu = SideMenuNavigationController(rootViewController: (storyboard?.instantiateViewController(withIdentifier: "ProfileSideMenuVC"))!, settings: sideMenuSet)
        rightMenu.setNavigationBarHidden(true, animated: false)
        present(rightMenu, animated: true, completion: nil)

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
