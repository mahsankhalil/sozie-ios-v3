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
        navigationItem.backBarButtonItem?.width = 30
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupShopNavBar() {
        let logo = UIImage(named: "NavBarLogo")
        setupBackgroundImage()
        let imageView = UIImageView(image:logo)
        navigationItem.titleView = imageView
    }
    func setupWishListNavBar() {
        let logo = UIImage(named: "NavBarLogo")
        setupBackgroundImage()
        let imageView = UIImageView(image:logo)
        navigationItem.titleView = imageView
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
