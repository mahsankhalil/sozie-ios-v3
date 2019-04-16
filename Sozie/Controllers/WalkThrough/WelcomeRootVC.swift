//
//  WelcomeRootVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 4/13/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class WelcomeRootVC: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    var userType: UserType?
    var signUpDict: [String: Any]?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func crossButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let destVC = segue.destination as? WelcomePageVC {
            destVC.pageDelegate = self
            destVC.userType = userType
        }
        if var signUpInfoProvider = segue.destination as? SignUpInfoProvider {
            signUpInfoProvider.signUpInfo = signUpDict
        }
    }
}

extension WelcomeRootVC: PageControlIndexProviding {
    func pageChanged(index: Int) {
        self.pageControl.currentPage = index
    }
}
extension WelcomeRootVC: SignUpInfoProvider {
    var signUpInfo: [String: Any]? {
        get { return signUpDict }
        set (newInfo) {
            signUpDict = newInfo
        }
    }
}
