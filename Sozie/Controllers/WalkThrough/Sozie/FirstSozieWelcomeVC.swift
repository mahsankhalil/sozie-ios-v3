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

    @IBOutlet weak var detailLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let formattedString = NSMutableAttributedString()
        formattedString.normal("Sozies help shoppers by trying-on, taking pictures and reviewing fashion.\nThe more you help, the more you make.\n\nCheck your ").bold("Balance ").normal("to see how much you've made and ").bold("Cash out").normal("!")
        detailLabel.attributedText = formattedString

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
