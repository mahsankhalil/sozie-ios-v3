//
//  BaseViewController.swift
//  Sozie
//
//  Created by Danial Zahid on 16/12/2018.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit
import EasyTipView
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
        let imageView = UIImageView(image: logo)
        navigationItem.titleView = imageView
        navigationController?.navigationBar.layer.borderWidth = 1.0
        navigationController?.navigationBar.layer.borderColor = UIColor(hex: "707070").cgColor.copy(alpha: 0.05)

    }

    func setupBrandNavBar(imageURL: String) {
        let titleView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 150.0, height: 19.5))
        let imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 150.0, height: 19.5))
        imageView.contentMode = .scaleAspectFit
        imageView.sd_setImage(with: URL(string: imageURL), completed: nil)
        titleView.addSubview(imageView)
        navigationItem.titleView = titleView
        navigationController?.navigationBar.layer.borderWidth = 1.0
        navigationController?.navigationBar.layer.borderColor = UIColor(hex: "707070").cgColor.copy(alpha: 0.05)
    }
    func showCancelButtonAfterDelay() {
        perform(#selector(showCancelButton), with: nil, afterDelay: 0.5)
    }
    @objc func showCancelButton() {
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        cancelButton.tintColor = UIColor(hex: "888888")
        navigationItem.leftBarButtonItem = cancelButton
        showCancelButtonTipView()
    }
    func showCancelButtonTipView() {
    }
    func showTagItemButton() {
        let tagItemButton = UIBarButtonItem(title: "Tag Item", style: .plain, target: self, action: #selector(tagItemButtonTapped))
        tagItemButton.tintColor = UIColor(hex: "888888")
        navigationItem.rightBarButtonItem = tagItemButton
    }
    @objc func tagItemButtonTapped() {
    }
    @objc func cancelButtonTapped() {
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.imageTaken = nil
    }
    func showNextButton() {
        let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextButtonTapped))
        nextButton.tintColor = UIColor(hex: "888888")
        navigationItem.rightBarButtonItem = nextButton
    }

    @objc func nextButtonTapped() {
    }

    func setupProfileNavBar() {
        setupBackgroundImage()
        navigationItem.titleView = nil
    }

    func setupBackgroundImage() {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage().resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), resizingMode: UIImage.ResizingMode.stretch), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true

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
