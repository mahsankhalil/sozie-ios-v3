//
//  AcceptRequestTutorialVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 7/18/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class AcceptRequestTutorialVC: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
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
            if string == "Now let's fulfil the request!  When live, you will have 24 hours to do this but for now click on\n    UPLOAD PICTURE    " {
                let stringToColor = "    UPLOAD PICTURE    "
                let range = (string as NSString).range(of: stringToColor)
                let attribute = NSMutableAttributedString.init(string: string)
                attribute.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor(hex: "13AEF2") , range: range)
                attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white , range: range)
                textLabel.attributedText = attribute
            }
//            textLabel.text = string
        }
        if let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "Arrow-Gif", withExtension: "gif")!) {
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
