//
//  RequestInStockTutorialVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 7/16/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class RequestInStockTutorialVC: UIViewController {

    @IBOutlet weak var labelView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        labelView.layer.borderWidth = 1.0
        labelView.layer.cornerRadius = 3.0
        labelView.layer.borderColor = UIColor(hex: "9C9C9C").cgColor
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
