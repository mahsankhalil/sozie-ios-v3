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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        labelView.layer.borderWidth = 0.5
        labelView.layer.cornerRadius = 10.0
        labelView.layer.borderColor = UIColor(hex: "9C9C9C").cgColor
        if let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "Arrow-Gif", withExtension: "gif")!)
        {
            let arrowGifImage = UIImage.sd_animatedGIF(with: imageData)
            imageViewOne.image = arrowGifImage
            imageViewTwo.image = arrowGifImage
            imageViewThree.image = arrowGifImage

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
