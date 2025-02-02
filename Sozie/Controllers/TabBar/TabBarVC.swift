//
//  TabBarVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/25/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import SDWebImage
class TabBarVC: UITabBarController {

    var currentBrandId: Int?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        populateUIOfSozieType()
        currentBrandId = UserDefaultManager.getCurrentUserObject()?.brand
        self.delegate = self
        self.view.backgroundColor = UIColor.white
//        Intercom.setLauncherVisible(true)
//        Intercom.setBottomPadding(30.0)
        NotificationCenter.default.addObserver(self, selector: #selector(updateBadge), name: Notification.Name(rawValue: "updateBadge"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showProfileTab), name: Notification.Name(rawValue: "showProfileTab"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showInstructions), name: Notification.Name(rawValue: "ShowInstructions"), object: nil)
    }

    @objc func showInstructions() {
        self.selectedIndex = 2
        if let cntroller = self.viewControllers![2] as? UINavigationController {
            cntroller.popToRootViewController(animated: false)
        }
    }
    @objc func showProfileTab() {
        self.selectedIndex = 2
    }
    @objc func updateBadge() {
        if Intercom.unreadConversationCount() == 0 {
            self.tabBar.items?[3].badgeValue = nil
        } else {
            self.tabBar.items?[3].badgeValue =  String(Intercom.unreadConversationCount())
        }
    }

    // MARK: - Custom Methods
    func populateUIOfSozieType() {
        var genderImageString = ""
        if let gender = UserDefaultManager.getCurrentUserGender() {
            if gender == "M" {
                genderImageString = "-Blue"
            }
        }
        let browseNC = self.storyboard?.instantiateViewController(withIdentifier: "BrowseNC")
        browseNC?.tabBarItem = UITabBarItem(title: "Browse", image: UIImage(named: "Shop"), selectedImage: UIImage(named: "Shop Selected" + genderImageString))
        let wishListNC = self.storyboard?.instantiateViewController(withIdentifier: "WishListNC")
        wishListNC?.tabBarItem = UITabBarItem(title: "Saved Requests", image: UIImage(named: "Whish List"), selectedImage: UIImage(named: "Wish List Selected" + genderImageString))
        var imageIcon = UIImage(named: "Profile icon")
        if let user = UserDefaultManager.getCurrentUserObject() {
            if let image = user.picture {
                SDWebImageDownloader().downloadImage(with: URL(string: image)) { (picture, _, _, _) in
                    if picture != nil {
                        imageIcon = picture?.scaleImageToSize(newSize: CGSize(width: 30.0, height: 30.0))
                        imageIcon = imageIcon?.circularImage(15.0)!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)

                        if let desiredVC = self.viewControllers?[2] {
                            desiredVC.tabBarItem = UITabBarItem(title: "Requests", image: imageIcon, selectedImage: imageIcon)
                        }
                    }
                }
            }
        }
        let profileNC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileNC")
        profileNC?.tabBarItem = UITabBarItem(title: "Requests", image: imageIcon, selectedImage: UIImage(named: "Profile icon-Selected" + genderImageString))
        let helpVc = UIViewController()
        helpVc.tabBarItem = UITabBarItem(title: "Help", image: UIImage(named: "Help"), selectedImage: UIImage(named: "Help Selected"))
        self.viewControllers = ([browseNC, wishListNC, profileNC, helpVc] as! [UIViewController])
        if let user = UserDefaultManager.getCurrentUserObject() {
            if user.tutorialCompleted == true {
                self.showProfileTab()
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
extension TabBarVC: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if self.customizableViewControllers?.index(of: viewController) == 0 {
            if currentBrandId != UserDefaultManager.getCurrentUserObject()?.brand {
                if let navCntrlr = viewController as? UINavigationController {
                    navCntrlr.popToRootViewController(animated: true)
                }
                currentBrandId = UserDefaultManager.getCurrentUserObject()?.brand
            }
        } else if self.customizableViewControllers?.index(of: viewController) == 2 {
            if UserDefaultManager.getIfBrowseTutorialShown() == false {
                UserDefaultManager.setBrowserTutorialShown()
            }

        } else if self.customizableViewControllers?.index(of: viewController) == 3 {
            Intercom.presentMessenger()
            return false
        }
        return true
    }
}
