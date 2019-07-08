//
//  SozieRequestTutorialVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 7/8/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
protocol SozieRequestTutorialDelegate: class {
    func infoButtonTapped()
}
class SozieRequestTutorialVC: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var infoButton: UIButton!
    weak var delegate: SozieRequestTutorialDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        topView.layer.borderWidth = 1.0
        topView.layer.cornerRadius = 3.0
        topView.layer.borderColor = UIColor(hex: "9C9C9C").cgColor
    }

    @IBAction func infoButtonTapped(_ sender: Any) {
        delegate?.infoButtonTapped()
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
