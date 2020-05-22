//
//  NearbyStoresTutorialVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 7/18/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class NearbyStoresTutorialVC: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        labelView.layer.borderWidth = 1.0
        labelView.layer.cornerRadius = 3.0
        labelView.layer.borderColor = UIColor(hex: "9C9C9C").cgColor
        if let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "Arrow-Gif", withExtension: "gif")!) {
            let arrowGifImage = UIImage.sd_animatedGIF(with: imageData)
            imageView.image = arrowGifImage
        }
//        let string = "Enter your zip code or city and press     FIND    "
//        let stringToColor = "    FIND    "
//        let range = (string as NSString).range(of: stringToColor)
//        let attribute = NSMutableAttributedString.init(string: string)
//        attribute.addAttribute(NSAttributedString.Key.backgroundColor, value: UtilityManager.getGenderColor(), range: range)
//        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range)
//        textLabel.attributedText = attribute
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
