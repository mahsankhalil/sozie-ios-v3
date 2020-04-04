//
//  TutorialProgressVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 7/19/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
protocol TutorialProgressDelegate: class {
    func tutorialSkipButtonTapped()
}
class TutorialProgressVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var skipButton: UIButton!
    weak var delegate: TutorialProgressDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        progressView.layer.cornerRadius = 2.0
        progressView.transform = CGAffineTransform(scaleX: 1.0, y: 7.0)
        progressView.clipsToBounds = true
    }
    func updateProgress(progress: Float) {
        progressView.progress = progress
    }
    func updateProgressTitle(string: NSAttributedString) {
        titleLabel.attributedText = string
    }
    @IBAction func skipButtonTapped(_ sender: Any) {
        self.view.removeFromSuperview()
        UserDefaultManager.setPostTutorialShown()
        delegate?.tutorialSkipButtonTapped()
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
