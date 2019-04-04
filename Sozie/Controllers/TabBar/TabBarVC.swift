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
        if UserDefaultManager.getCurrentUserType() == UserType.shopper.rawValue {
            populateUIOfShopperType()
        } else {
            populateUIOfSozieType()
            currentBrandId = UserDefaultManager.getCurrentUserObject()?.brand
        }
        self.delegate = self
    }

    // MARK: - Custom Methods
    func populateUIOfShopperType() {
        let shopNC = self.storyboard?.instantiateViewController(withIdentifier: "BrowseNC")
        shopNC?.tabBarItem = UITabBarItem(title: "Shop", image: UIImage(named: "Shop"), selectedImage: UIImage(named: "Shop Selected"))
        let wishListNC = self.storyboard?.instantiateViewController(withIdentifier: "WishListNC")
        wishListNC?.tabBarItem = UITabBarItem(title: "Wish List", image: UIImage(named: "Whish List"), selectedImage: UIImage(named: "Wish List Selected"))
        let profileNC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileNC")
        profileNC?.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "Profile icon"), selectedImage: UIImage(named: "Profile icon-Selected"))
        self.viewControllers = ([shopNC, wishListNC, profileNC] as! [UIViewController])
    }
    func populateUIOfSozieType() {
        let browseNC = self.storyboard?.instantiateViewController(withIdentifier: "BrowseNC")
        browseNC?.tabBarItem = UITabBarItem(title: "Browse", image: UIImage(named: "Browse icon"), selectedImage: UIImage(named: "Browse icon-Selected"))
        let cameraVc = UIViewController()
        cameraVc.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Camera icon"), selectedImage: UIImage(named: "Camera icon-Selected"))
        let profileNC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileNC")
        profileNC?.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "Profile icon"), selectedImage: UIImage(named: "Profile icon-Selected"))
        self.viewControllers = ([browseNC, cameraVc, profileNC] as! [UIViewController])

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
        if UserDefaultManager.getIfShopper() == false {
            if self.customizableViewControllers?.index(of: viewController) == 1 {
                UtilityManager.openImagePickerActionSheetFrom(viewController: self)
                return false
            } else if self.customizableViewControllers?.index(of: viewController) == 0 {
                if currentBrandId != UserDefaultManager.getCurrentUserObject()?.brand {
                    if let navCntrlr = viewController as? UINavigationController {
                        navCntrlr.popToRootViewController(animated: true)
                    }
                    currentBrandId = UserDefaultManager.getCurrentUserObject()?.brand
                }
            }
        }
        return true
    }
}
extension TabBarVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let scaledImg = pickedImage.scaleImageToSize(newSize: CGSize(width: 750, height: (pickedImage.size.height/pickedImage.size.width)*750))
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.imageTaken = scaledImg
            if let browseNC = (self.viewControllers![0] as? UINavigationController) {
                if browseNC.viewControllers.count > 1 {
                    browseNC.popToRootViewController(animated: true)
                }
                if let browseVC = (browseNC.viewControllers[0]) as? BrowseVC {
                    browseVC.showCancelButtonAfterDelay()
                    browseVC.showTipeViewAfterDelay()
                }
            }
            self.selectedIndex = 0
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
