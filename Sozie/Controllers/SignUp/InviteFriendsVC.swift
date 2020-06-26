//
//  InviteFriendsVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/10/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import SVProgressHUD
class InviteFriendsVC: UIViewController {

    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var referalCodeLabel: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var inviteBtn: DZGradientButton!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var inviteLaterLabel: UILabel!
    var isFromSideMenu: Bool?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let fromMenu = isFromSideMenu {
            if fromMenu == true {
//                inviteLaterLabel.isHidden = true
                skipBtn.isHidden = true
            }
        }
        SVProgressHUD.show()
        ServerManager.sharedInstance.getReferalCode(params: [:]) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            if isSuccess {
                let code = (response as! ReferalResponse).code
                self.referalCodeLabel.text = code
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
    // MARK: - Actions
    @IBAction func backBtnTapped(_ sender: Any) {
        if let fromMenu = isFromSideMenu {
            if fromMenu == true {
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func copyButtonTapped(_ sender: Any) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = referalCodeLabel.text
    }
    @IBAction func inviteBtnTapped(_ sender: Any) {
        let objectsToShare = ["https://itunes.apple.com/us/app/sozie-shop2gether/id1363346896?ls=1&mt=8"]
        UtilityManager.showActivityControllerWith(objectsToShare: objectsToShare, viewController: self)
    }

    @IBAction func skipBtnTapped(_ sender: Any) {
        self.changeRootVCToTabBarNC()

    }
}
