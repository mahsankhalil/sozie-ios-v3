//
//  AddFitTipsTutorialVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 7/18/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class AddFitTipsTutorialVC: UIViewController {
    @IBOutlet weak var labelView: UIView!

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        labelView.layer.borderWidth = 1.0
        labelView.layer.cornerRadius = 3.0
        labelView.layer.borderColor = UIColor(hex: "9C9C9C").cgColor
        if let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "Down-Arrow", withExtension: "gif")!)
        {
            let arrowGifImage = UIImage.sd_animatedGIF(with: imageData)
            imageView.image = arrowGifImage
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
