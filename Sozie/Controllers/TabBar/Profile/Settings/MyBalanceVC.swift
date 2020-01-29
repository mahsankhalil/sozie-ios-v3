//
//  MyBalanceVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 3/13/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import SVProgressHUD
class MyBalanceVC: UIViewController {

    @IBOutlet weak var checkoutBackgroundView: DZGradientView!
    @IBOutlet weak var totalBalanceBackgroundView: DZGradientView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var minimumBalanceLabel: UILabel!
    @IBOutlet weak var checkoutButton: UIButton!
    @IBOutlet weak var balanceLabel: UILabel!
    var currentbalance: Float = 0.0
    var currencySymbol = "$"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchDataFromServer()
        checkoutBackgroundView.layer.cornerRadius = Styles.sharedStyles.buttonCornerRadius
        if let user = UserDefaultManager.getCurrentUserObject() {
            if let country = user.country {
                if country == 1 {
                    currencySymbol = "£"
                } else {
                    currencySymbol = "$"
                }
            }
        }
        minimumBalanceLabel.text = "\"You must have at least " + currencySymbol + "10 to be paid out\""
    }

    func fetchDataFromServer() {
        SVProgressHUD.show()
        ServerManager.sharedInstance.getCurrentBalance(params: [:]) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            if isSuccess {
                let balance = (response as! BalanceResponse).balance
                self.currentbalance = balance
                self.balanceLabel.text = self.currencySymbol + String(format: "%0.2f", balance)
            } else {
                UtilityManager.showErrorMessage(body: (response as! Error).localizedDescription, in: self)
            }
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
    @IBAction func backButtonTapped(_ sender: Any) {
        if self.navigationController == nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func checkoutButtonTapped(_ sender: Any) {
        if currentbalance < 10 {
            UtilityManager.showMessageWith(title: "Insufficient Amount", body: "To cash out you need a minimum of " + currencySymbol + "10", in: self)
            return
        }
        let popUpInstnc = ConfirmEmailCashoutPopUp.instance()
        let popUpVC = PopupController
            .create(self)
            .show(popUpInstnc)
        _ = popUpVC.customize([.movesAlongWithKeyboard(true)])
        _ = popUpVC.didCloseHandler { (_) in
        }
        popUpInstnc.closeHandler = { []  in
            popUpVC.dismiss()
            self.fetchDataFromServer()
        }
//        SVProgressHUD.show()
//        ServerManager.sharedInstance.cashOut(params: [:]) { (isSuccess, response) in
//            SVProgressHUD.dismiss()
//            if isSuccess {
//                UtilityManager.showMessageWith(title: "Success!", body: (response as! ValidateRespose).detail, in: self)
//            } else {
//                UtilityManager.showErrorMessage(body: (response as! Error).localizedDescription, in: self)
//            }
//        }
    }
}
