//
//  MainTabBarController.swift
//  Sozie
//
//  Created by Danial Zahid on 19/12/2018.
//  Copyright © 2018 Danial Zahid. All rights reserved.
//

import UIKit
import SVProgressHUD

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        Styles.sharedStyles.applyGlobalAppearance()
        self.selectedIndex = 0
        self.delegate = self
//        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived), name: NSNotification.Name(rawValue: "pushNotificationReceived"), object: nil)
        if ApplicationManager.sharedInstance.user == nil {
//            SVProgressHUD.show()
//            RequestManager.getUser(successBlock: { (response) in
//                SVProgressHUD.dismiss()
////                let user = User(dictionary: response)
////                ApplicationManager.sharedInstance.user = user
//
//
//
//            }, failureBlock: { (error) in
//                UtilityManager.showErrorMessage(body: error, in: self)
//            })
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func notificationReceived() {
        let tabbarItem = self.tabBar.items![0]
        tabbarItem.badgeValue = "1"
    }

    override func viewWillLayoutSubviews() {
        var tabFrame = self.tabBar.frame
        // - 40 is editable , the default value is 49 px, below lowers the tabbar and above increases the tab bar size
        tabFrame.size.height = 40
        tabFrame.origin.y = self.view.frame.size.height - 40
        self.tabBar.frame = tabFrame
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
