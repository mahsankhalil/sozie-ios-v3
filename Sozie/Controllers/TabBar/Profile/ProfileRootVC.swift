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
    var tabVC : ProfileTabsPageVC?
    @IBOutlet weak var tabView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tabVC = ProfileTabsPageVC()
        tabVC?.view.backgroundColor = UIColor.clear
        tabView.addSubview((tabVC?.view)!)
        tabView.autoresizesSubviews = true
        tabVC?.view.frame = CGRect(x: 0.0, y: 0.0, width: tabView.frame.size.width, height: tabView.frame.size.height)
        self.addChild(tabVC!)
        setupProfileNavBar()
        SideMenuManager.default.menuRightNavigationController = storyboard!.instantiateViewController(withIdentifier: "RightMenuNavigationController") as? UISideMenuNavigationController
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuWidth = UIScreen.main.bounds.size.width - 60.0
        SideMenuManager.default.menuAnimationFadeStrength = 0.5
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
