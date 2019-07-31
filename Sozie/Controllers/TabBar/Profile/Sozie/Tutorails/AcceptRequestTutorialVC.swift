//
//  AcceptRequestTutorialVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 7/18/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class AcceptRequestTutorialVC: UIViewController {
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var labelView: UIView!
    var descriptionString: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        labelView.layer.borderWidth = 1.0
        labelView.layer.cornerRadius = 3.0
        labelView.layer.borderColor = UIColor(hex: "9C9C9C").cgColor
        if let string = descriptionString {
            textLabel.text = string
        }
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
