//
//  FirstSozieWelcomeVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 4/13/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class FirstSozieWelcomeVC: UIViewController, WelcomeModel, IndexProviding {

    weak var delegate: WelcomeButtonActionsDelegate?
    var index: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func nextButtonTapped(_ sender: Any) {
        delegate?.nextButtonTapped()
    }
    @IBAction func skipButtonTapped(_ sender: Any) {
        delegate?.skipButtonTapped()
    }

}
