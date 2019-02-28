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
        if UserDefaultManager.getIfShopper() {
            soziesVC = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "SoziesVC") as? SoziesVC
            requestsVC = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "RequestsVC") as? RequestsVC
            tabItems = [(soziesVC, "Sozies"), (requestsVC, "Requests")] as! [(viewController: UIViewController, title: String)]
        } else {
            sozieRequestsVC = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "SozieRequestsVC") as? SozieRequestsVC
            myUploadsVC = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "MyUploadsVC") as? MyUploadsVC
            tabItems = [(sozieRequestsVC, "Sozie Requests"), (myUploadsVC, "My Uploads")] as! [(viewController: UIViewController, title: String)]
        }
        
        option.tabWidth = UIScreen.main.bounds.size.width / CGFloat(tabItems.count)
        option.tabHeight = 44.0
        option.currentColor = UIColor(hex: "FC8C8C")
        option.defaultColor = UIColor(hex: "888888")
        option.pageBackgoundColor = UIColor.clear
        option.font = UIFont(name: Font.standard.rawValue, size: 13.0)!
        self.view.backgroundColor = UIColor.clear

    }

    //    override func updateNavigationBar() {
    //
    //    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //         Do any additional setup after loading the view.
//        self.view.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 356)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.view.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 356)
    }
}
