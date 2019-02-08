//
//  ViewController.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/1/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

extension UIViewController {
    func changeRootVCToTabBarNC()
    {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        guard let rootViewController = window.rootViewController else {
            return
        }
        
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "tabBarNC")
        vc.view.frame = rootViewController.view.frame
        vc.view.layoutIfNeeded()
        
        UIView.transition(with: window, duration: 1.0, options: .transitionFlipFromRight, animations: {
            window.rootViewController = vc
        }, completion: { completed in
            // maybe do something here
        })
    }
    
    func changeRootVCToLoginNC()
    {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        guard let rootViewController = window.rootViewController else {
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LandingViewController")
        vc.view.frame = rootViewController.view.frame
        vc.view.layoutIfNeeded()
        
        UIView.transition(with: window, duration: 1.0, options: .transitionFlipFromLeft, animations: {
            window.rootViewController = vc
        }, completion: { completed in
            // maybe do something here
        })
    }
}
