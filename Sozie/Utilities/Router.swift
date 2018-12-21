//
//  Router.swift
//  Map Hunt
//
//  Created by Danial Zahid on 16/08/2017.
//  Copyright © 2017 Fitsmind. All rights reserved.
//

import UIKit


class Router: NSObject {
    
    static func logout() {
        ApplicationManager.sharedInstance.session_id = ""
        
        /*RequestManager.logoutUser(param: [:], successBlock: { (response) in
            
        }) { (error) in
            
        }
        UserDefaults.standard.set(nil, forKey: UserDefaultKey.sessionID)
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.geoFeedRadius)
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.ownPostsFilter)
 */
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: SignInViewController.identifier)
 
        if let window = UIApplication.shared.delegate?.window {
            UIView.transition(with: window!, duration: 0.5, options: UIView.AnimationOptions.transitionFlipFromLeft, animations: {
                window?.rootViewController = vc
            }, completion: nil)
        }
    }
    
    /*
    static func showMainTabBar() {
        let tabBarController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "mainTabBarController") as! UITabBarController
        if let window = UIApplication.shared.delegate?.window {
            UIView.transition(with: window!, duration: 0.5, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
                window?.rootViewController = tabBarController
            }, completion: nil)
        }
    }
    
    
    
    static func showProfileViewController(user: User, from controller: UIViewController) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ProfileViewController.storyboardID) as! ProfileViewController
        vc.user = user
        controller.navigationController?.show(vc, sender: nil)
    
    }
    */
    
    
}
