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
        let viewCOntroller = storyboard.instantiateViewController(withIdentifier: "tabBarNC")
        viewCOntroller.view.frame = rootViewController.view.frame
        viewCOntroller.view.layoutIfNeeded()
        UIView.transition(with: window, duration: 1.0, options: .transitionFlipFromRight, animations: {
            window.rootViewController = viewCOntroller
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
