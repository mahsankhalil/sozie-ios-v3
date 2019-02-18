//
//  BaseViewController.swift
//  Sozie
//
//  Created by Danial Zahid on 16/12/2018.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back-button-white")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back-button-white")
        navigationItem.backBarButtonItem?.width = 80
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupSozieLogoNavBar() {
        let logo = UIImage(named: "NavBarLogo")
        setupBackgroundImage()
        let imageView = UIImageView(image:logo)
        navigationItem.titleView = imageView
        navigationController?.navigationBar.layer.borderWidth = 1.0
        navigationController?.navigationBar.layer.borderColor = UIColor(hex: "707070").cgColor.copy(alpha: 0.05)

    }
    
    func setupProfileNavBar() {
        setupBackgroundImage()
        navigationItem.titleView = nil
    }
    
    func setupBackgroundImage() {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage().resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), resizingMode: UIImage.ResizingMode.stretch), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
//    func sideMenuBtnTapped()
//    {
//
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
