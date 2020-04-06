//
//  SelectPicturesTutorialVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 7/18/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class SelectPicturesTutorialVC: UIViewController {
    @IBOutlet weak var labelView: UIView!
    @IBOutlet weak var imageViewOne: UIImageView!
    @IBOutlet weak var imageViewTwo: UIImageView!
    @IBOutlet weak var imageViewThree: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tutorialImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        labelView.layer.borderWidth = 0.5
        labelView.layer.cornerRadius = 10.0
        labelView.layer.borderColor = UIColor(hex: "9C9C9C").cgColor
        if let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "Arrow-Gif", withExtension: "gif")!) {
            let arrowGifImage = UIImage.sd_animatedGIF(with: imageData)
            imageViewOne.image = arrowGifImage
            imageViewTwo.image = arrowGifImage
            imageViewThree.image = arrowGifImage

        }
        if let gender = UserDefaultManager.getCurrentUserGender() {
            if gender == "M" {
                let descriptionString = NSMutableAttributedString()
                descriptionString.bold("Time to upload your pics! Follow the instructions below and you will be good to go!\n\n", size: 13.0).normal("1. Upload a ")
                    .bold("full", size: 13.0).normal(" front, back, and side view at the same angle as the pic below.\n\n2. Make sure your pictures are ").bold("bright 💡", size: 13.0).normal("\n\n3. ").bold("No selfies!\n\n", size: 13.0).normal("4. We ").bold("DO", size: 13.0).normal(" want pics to be stylized with ").bold("shoes👟 well-groomed hair,", size: 13.0).normal(" and ").bold("appearance", size: 13.0).normal(" ")
                descriptionLabel.attributedText = descriptionString
                tutorialImageView.image = UIImage(named: "MaleTutorial")
            } else {
                let descriptionString = NSMutableAttributedString()
                descriptionString.bold("Time to upload your pics! Follow the instructions below and you will be good to go!\n\n", size: 13.0).normal("1. Upload a ").bold("full", size: 13.0).normal(" front, back, and side view at the same angle as the pic below.\n\n2. Make sure your pictures are ").bold("bright 💡", size: 13.0).normal("\n\n3. ").bold("No selfies!\n\n", size: 13.0).normal("4. We ").bold("DO", size: 13.0).normal(" want pics to be stylized with ").bold("shoes👠 well-groomed hair,", size: 13.0).normal(" and ").bold("makeup💄", size: 13.0)
                descriptionLabel.attributedText = descriptionString
                tutorialImageView.image = UIImage(named: "Depinder")
            }
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
