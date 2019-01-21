//
//  ServerResponsePopUp.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/21/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class ServerResponsePopUp: UIViewController {

    @IBOutlet weak var okBtn: DZGradientButton!
    @IBOutlet weak var detailTxtLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var titleImgVu: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    class func instance() -> ServerResponsePopUp {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let instnce = storyboard.instantiateViewController(withIdentifier: "ServerResponsePopUp") as! ServerResponsePopUp
        instnce.view.layer.cornerRadius = 10.0
        instnce.view.clipsToBounds = true
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
    }
    
}
extension ServerResponsePopUp: PopupContentViewController {
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        popupController.popupView.layer.cornerRadius = 10.0
        popupController.popupView.clipsToBounds = true
        return CGSize(width: UIScreen.main.bounds.size.width - 26.0 ,height: 270.0)
    }
}
