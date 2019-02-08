//
//  PopupNavController.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/4/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class PopupNavController: UINavigationController {

    var navigationHandler: (() -> Void)?

    var popupType: PopupType?
    var brandList : [Brand]?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self
    }
    
    class func instance(type : PopupType , brandList : [Brand]) -> PopupNavController {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let instnce = storyboard.instantiateViewController(withIdentifier: "PopupNavController") as! PopupNavController
        instnce.popupType = type
        instnce.brandList = brandList
        return instnce
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
extension PopupNavController: PopupContentViewController {
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        if (self.topViewController as? SelectionPopupVC) != nil {
            if popupType == PopupType.category {
                return CGSize(width: UIScreen.main.bounds.size.width  ,height: 200)
            } else {
                return CGSize(width: UIScreen.main.bounds.size.width  ,height: 354)
            }
        } else {
            if popupType == PopupType.category {
                return CGSize(width: UIScreen.main.bounds.size.width  ,height: 440)

            } else {
                return CGSize(width: UIScreen.main.bounds.size.width  ,height: 165)

            }
        }
    }
}
extension PopupNavController : UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationHandler!()
        if let vc = self.viewControllers[0] as? ListingPopupVC
        {
            vc.setPopupType(type: popupType, brandList: brandList)
        }
    }
}
