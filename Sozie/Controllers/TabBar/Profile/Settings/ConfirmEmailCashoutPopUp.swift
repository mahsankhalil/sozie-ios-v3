//
//  ConfirmEmailCashoutPopUp.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 8/29/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import SVProgressHUD
import StoreKit
class ConfirmEmailCashoutPopUp: UIViewController {

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    var closeHandler: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emailTextField.delegate = self
    }
    class func instance() -> ConfirmEmailCashoutPopUp {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let instnce = storyboard.instantiateViewController(withIdentifier: "ConfirmEmailCashoutPopUp") as! ConfirmEmailCashoutPopUp
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
    func submitEmailForCashOut(email: String) {
        let dataDict = ["user_paypal_email": email]
        SVProgressHUD.show()
        ServerManager.sharedInstance.cashOut(params: dataDict) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            if isSuccess {
                UtilityManager.showMessageWith(title: "Success!", body: (response as! ValidateRespose).detail, in: self, okBtnTitle: "Ok", cancelBtnTitle: nil, dismissAfter: nil, leftAligned: nil ) {
                    self.closeHandler?()
                    SKStoreReviewController.requestReview()
                }
            } else {
                UtilityManager.showErrorMessage(body: (response as! Error).localizedDescription, in: self)
            }
        }
    }
    @IBAction func submitButtonTapped(_ sender: Any) {
        if let email = emailTextField.text {
            if email.isValidEmail() {
                UtilityManager.showMessageWith(title: "Confirmation!", body: "Are you sure to get cashout on this email\n" + email, in: self, okBtnTitle: "Yes", cancelBtnTitle: "No", dismissAfter: nil, leftAligned: nil) {
                    self.submitEmailForCashOut(email: email)
                }
            } else {
                UtilityManager.showMessageWith(title: "Warning!", body: "Please enter valid email", in: self)
            }
        } else {
            UtilityManager.showMessageWith(title: "Warning!", body: "Please enter valid email", in: self)
        }
    }
}
extension ConfirmEmailCashoutPopUp: PopupContentViewController {
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return CGSize(width: 274.0, height: 214.0)
    }
}
extension ConfirmEmailCashoutPopUp: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
