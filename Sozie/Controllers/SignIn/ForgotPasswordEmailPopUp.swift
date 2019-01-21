//
//  ForgotPasswordEmailPopUp.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/21/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class ForgotPasswordEmailPopUp: UIViewController {

    var closeHandler: (() -> Void)?

    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var recoverPasswordBtn: DZGradientButton!
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var titleLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    class func instance() -> ForgotPasswordEmailPopUp {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let instnce = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordEmailPopUp") as! ForgotPasswordEmailPopUp
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
    @IBAction func recoverPasswordBtnTapped(_ sender: Any) {
    }
    @IBAction func closeBtnTapped(_ sender: Any) {
    }
    
}


extension ForgotPasswordEmailPopUp: PopupContentViewController {
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        popupController.popupView.layer.cornerRadius = 10.0
        popupController.popupView.clipsToBounds = true
        return CGSize(width: UIScreen.main.bounds.size.width - 26.0 ,height: 270.0)
    }
}
