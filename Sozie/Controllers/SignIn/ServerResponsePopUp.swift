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
    
    var titleImageName: String?
    var titleName: String?
    var detail: String?
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
    }
    
    class func instance(imageName: String, title: String, description: String) -> ServerResponsePopUp {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let instnce = storyboard.instantiateViewController(withIdentifier: "ServerResponsePopUp") as! ServerResponsePopUp
        instnce.titleImageName = imageName
        instnce.titleName = title
        instnce.detail = description
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
        return CGSize(width: UIScreen.main.bounds.size.width - 26.0 ,height: 300.0)
    }
}
