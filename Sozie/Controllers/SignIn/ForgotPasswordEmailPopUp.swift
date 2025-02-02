//
//  ForgotPasswordEmailPopUp.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/21/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

protocol ForgotPasswordEmailPopupDelegate: class {
    func recoverPasswordBtnTapped(email: String)
}
class ForgotPasswordEmailPopUp: UIViewController {

    var closeHandler: (() -> Void)?

    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var recoverPasswordBtn: DZGradientButton!
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var errorLbl: UILabel!
    weak var delegate: ForgotPasswordEmailPopupDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        emailTxtFld.becomeFirstResponder()
    }

    class func instance() -> ForgotPasswordEmailPopUp {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let instnce = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordEmailPopUp") as! ForgotPasswordEmailPopUp
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
        if self.emailTxtFld.text!.isValidEmail() {
            self.errorLbl.isHidden = true
            closeHandler!()
            delegate?.recoverPasswordBtnTapped(email: emailTxtFld.text!)
        } else {
            self.errorLbl.isHidden = false
        }
    }
    @IBAction func closeBtnTapped(_ sender: Any) {
        closeHandler!()
    }
}

extension ForgotPasswordEmailPopUp: PopupContentViewController {
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width - 26.0, height: 270.0)
    }
}
