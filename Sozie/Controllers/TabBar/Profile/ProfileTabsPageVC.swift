//
//  ProfileTabsPageVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/21/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class ProfileTabsPageVC: TabPageViewController {

    var soziesVC: SoziesVC?
    var requestsVC: RequestsVC?
    var sozieRequestsVC: SozieRequestsVC?
    var myUploadsVC: MyUploadsVC?

    override init() {
        super.init()
        
        sozieRequestsVC = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "SozieRequestsVC") as? SozieRequestsVC
        myUploadsVC = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "MyUploadsVC") as? MyUploadsVC
        tabItems = [(sozieRequestsVC, "Sozie Requests"), (myUploadsVC, "My Uploads")] as! [(viewController: UIViewController, title: String)]
        option.tabWidth = UIScreen.main.bounds.size.width / CGFloat(tabItems.count)
        option.tabHeight = 44.0
        option.currentColor = UtilityManager.getGenderColor() //UIColor(hex: "FC8C8C")
        option.defaultColor = UIColor(hex: "888888")
        option.pageBackgoundColor = UIColor.clear
        option.font = UIFont(name: Font.standard.rawValue, size: 13.0)!
        self.view.backgroundColor = UIColor.clear
        NotificationCenter.default.addObserver(self, selector: #selector(showInstructions), name: Notification.Name(rawValue: "ShowInstructions"), object: nil)
    }
    @objc func showInstructions() {
        self.displayControllerWithIndex(0, direction: .reverse, animated: true)
    }
    //    override func updateNavigationBar() {
    //
    //    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
