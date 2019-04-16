//
//  MeasurementTutorialVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 4/16/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class MeasurementTutorialVC: UIViewController {

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
    @IBAction func crossButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
