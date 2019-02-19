//
//  WishListVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/25/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class WishListVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noProductLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupSozieLogoNavBar()
        assignNoProductLabel()
        self.tableView.tableFooterView = UIView()
        
    }
    
    func assignNoProductLabel() {
        let imageAttachment =  NSTextAttachment()
        imageAttachment.image = UIImage(named:"Wish List Selected")
        //Set bound to reposition
        let imageOffsetY:CGFloat = -5.0;
        imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
        //Create string with attachment
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        //Initialize mutable string
        let completeText = NSMutableAttributedString(string: "Click on the ")
        //Add image to mutable string
        completeText.append(attachmentString)
        //Add your text to mutable string
        let  textAfterIcon = NSMutableAttributedString(string: " \n under your favourite picture or\n Sozie to save it here for viewing later")
        completeText.append(textAfterIcon)
        self.noProductLabel.textAlignment = .center
        self.noProductLabel.attributedText = completeText
        
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
