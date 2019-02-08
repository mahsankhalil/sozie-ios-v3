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

    var popUpTitle: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self
    }
    
    class func instance(title : String) -> PopupNavController {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let instnce = storyboard.instantiateViewController(withIdentifier: "PopupNavController") as! PopupNavController
        instnce.popUpTitle = title
        
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
            return CGSize(width: UIScreen.main.bounds.size.width  ,height: 200)
        } else {
            return CGSize(width: UIScreen.main.bounds.size.width  ,height: 440)
        }
    }
}
extension PopupNavController : UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationHandler!()
        if let vc = self.viewControllers[0] as? ListingPopupVC
        {
            vc.setupData(title: popUpTitle!)
        }
    }
}
