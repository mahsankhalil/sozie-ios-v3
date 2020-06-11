//
//  FitTipsNavigationController.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 7/3/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class FitTipsNavigationController: UINavigationController {
    var fitTips: [FitTips]?
    var closeHandler: (() -> Void)?
    var navigationHandler: (() -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self
    }

    class func instance(fitTips: [FitTips]) -> FitTipsNavigationController {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let instnce = storyboard.instantiateViewController(withIdentifier: "FitTipsNavigationController") as! FitTipsNavigationController
        instnce.fitTips = fitTips
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
extension FitTipsNavigationController: PopupContentViewController {
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        if let destVC = self.topViewController as? FitTipsAnswerTableVC {
            if let tipsIndex = destVC.fitTipsIndex, let questionIndex = destVC.questionIndex {
                if let count = fitTips?[tipsIndex].question[questionIndex].options.count {
                    let height = (CGFloat(count) * 40.0) + 150.0
                    let maxHeight = UIScreen.main.bounds.size.height - 88.0
                    if height <= maxHeight {
                        return CGSize(width: UIScreen.main.bounds.size.width, height: height)
                    } else {
                        return CGSize(width: UIScreen.main.bounds.size.width, height: maxHeight)
                    }
                }
            }
        }
        if self.topViewController as? FitTipsAnswerTextVC != nil {
            if UIScreen.main.bounds.size.width < 375 {
                return CGSize(width: UIScreen.main.bounds.size.width, height: 230)
            } else {
                return CGSize(width: UIScreen.main.bounds.size.width, height: 330)
            }
        }
        if self.topViewController as? FitTipsAnswerRateVC != nil {
            return CGSize(width: UIScreen.main.bounds.size.width, height: 250)
        }
        return CGSize(width: UIScreen.main.bounds.size.width, height: 330)
    }
}
extension FitTipsNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationHandler!()
        if let destVC = self.viewControllers[0] as? FitTipsListingVC {
            destVC.fitTips = self.fitTips!
        }
    }
}
