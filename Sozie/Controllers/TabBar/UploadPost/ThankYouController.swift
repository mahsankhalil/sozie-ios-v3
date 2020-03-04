//
//  ThankYouController.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 9/19/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class ThankYouController: UIViewController {

    @IBOutlet weak var thankyouView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "ThankYouAnimation", withExtension: "gif")!) {
            let arrowGifImage = UIImage.sd_animatedGIF(with: imageData)
            imageView.image = arrowGifImage
        }
        thankyouView.layer.cornerRadius = 10.0
        thankyouView.layer.borderWidth = 0.5
        thankyouView.layer.borderColor = UIColor.lightGray.cgColor
        thankyouView.applyShadowWith(radius: 10.0, shadowOffSet: CGSize(width: 0.0, height: 15.0), opacity: 0.25)
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
