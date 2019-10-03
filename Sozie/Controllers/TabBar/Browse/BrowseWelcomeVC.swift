//
//  BrowseWelcomeVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 7/10/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
protocol BrowseWelcomeDelegate: class {
    func profileButtonTapped()
}
class BrowseWelcomeVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bottomViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var welcomeNoteView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    weak var delegate: BrowseWelcomeDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        welcomeNoteView.layer.cornerRadius = 20.0
        welcomeNoteView.layer.borderWidth = 1.0
        welcomeNoteView.layer.borderColor = UIColor(hex: "CCCCCC").cgColor
        bottomViewWidthConstraint.constant = (UIScreen.main.bounds.size.width - 15)/4
        if let firstName = UserDefaultManager.getCurrentUserObject()?.firstName {
            nameLabel.text = "Hi " + firstName + ","
        }
        if let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "Down-Arrow", withExtension: "gif")!) {
            let arrowGifImage = UIImage.sd_animatedGIF(with: imageData)
            imageView.image = arrowGifImage
        }
    }

    @IBAction func profileButtonTapped(_ sender: Any) {
        delegate?.profileButtonTapped()
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
