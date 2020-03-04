//
//  ViewController.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/1/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

extension UIViewController {

    func changeRootVCToTabBarNC() {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        guard let rootViewController = window.rootViewController else {
            return
        }
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "tabBarNC")
        viewController.view.frame = rootViewController.view.frame
        viewController.view.layoutIfNeeded()
        UIView.transition(with: window, duration: 1.0, options: .transitionFlipFromRight, animations: {
            let rootWindow = (UIApplication.shared.delegate as! AppDelegate).window
            _ = rootWindow?.rootViewController?.presentedViewController
            self.present(viewController, animated: false) {
                rootWindow?.rootViewController?.dismiss(animated: false) {
                    rootWindow?.rootViewController = viewController
                }
            }

        }, completion: nil)
        self.view.endEditing(true)
    }

    func changeRootVCToLoginNC() {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        guard let rootViewController = window.rootViewController else {
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewCOntroller = storyboard.instantiateViewController(withIdentifier: "LandingViewController")
        viewCOntroller.view.frame = rootViewController.view.frame
        viewCOntroller.view.layoutIfNeeded()
        UIView.transition(with: window, duration: 1.0, options: .transitionFlipFromLeft, animations: {
            window.rootViewController = viewCOntroller
        }, completion: nil)
    }
}
