//
//  ServerResponsePopUp.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/21/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class ServerResponsePopUp: UIViewController {

    var closeHandler: (() -> Void)?
    @IBOutlet weak var okBtn: DZGradientButton!
    @IBOutlet weak var detailTxtLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var titleImgVu: UIImageView!
    @IBOutlet weak var okButtonHeightConstraint: NSLayoutConstraint!

    var titleImageName: String?
    var titleName: String?
    var detail: String?
    var height: CGFloat = 300.0
    var isOkButtonHidden: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let imageName = titleImageName {
            self.titleImgVu.image = UIImage(named: imageName)
        }
        if let currentTitle = titleName {
            self.titleLbl.text = currentTitle
        }
        if let description = detail {
            self.detailTxtLbl.text = description
        }
        if isOkButtonHidden == true {
            self.okButtonHeightConstraint.constant = 0.0
            self.okBtn.isHidden = true
        } else {
            self.okButtonHeightConstraint.constant = 48.0
            self.okBtn.isHidden = false
        }
    }

    class func instance(imageName: String, title: String, description: String, height: CGFloat = 300, isOkButtonHidded: Bool = false ) -> ServerResponsePopUp {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let instnce = storyboard.instantiateViewController(withIdentifier: "ServerResponsePopUp") as! ServerResponsePopUp
        instnce.titleImageName = imageName
        instnce.titleName = title
        instnce.detail = description
        instnce.height = height
        instnce.isOkButtonHidden = isOkButtonHidded
        return instnce
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func okBtnTapped(_ sender: Any) {
        closeHandler!()
    }

}
extension ServerResponsePopUp: PopupContentViewController {
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width - 26.0, height: height)
    }
}
