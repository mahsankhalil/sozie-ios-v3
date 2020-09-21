//
//  ReferralPaymentPopupVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 9/21/20.
//  Copyright © 2020 Danial Zahid. All rights reserved.
//

import UIKit

class ReferralPaymentPopupVC: UIViewController {

    @IBOutlet weak var inviteFriendsButton: DZGradientButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    var textToShow: String?
    var closeHandler: (() -> Void)?
    class func instance(text: String) -> ReferralPaymentPopupVC {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let instnce = storyboard.instantiateViewController(withIdentifier: "ReferralPaymentPopupVC") as! ReferralPaymentPopupVC
        instnce.textToShow = text
        return instnce
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let str = textToShow {
            let data: Data = str.data(using: .nonLossyASCII)!
            let valueUnicode: String = String(data: data as Data, encoding: String.Encoding.utf8)!
            let dataa: NSData = valueUnicode.data(using: String.Encoding.utf8)! as NSData
            let valueEmoj: String = String(data: dataa as Data, encoding: String.Encoding.nonLossyASCII)!
            descriptionLabel.text = valueEmoj
        }
    }

    @IBAction func closeButtonTapped(_ sender: Any) {
        closeHandler!()
    }
    @IBAction func inviteFriendsButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let inviteFriendsVC = storyboard.instantiateViewController(withIdentifier: "InviteFriendsVC") as! InviteFriendsVC
        self.present(inviteFriendsVC, animated: true, completion: nil)
        closeHandler!()
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
extension ReferralPaymentPopupVC: PopupContentViewController {
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width - 26.0, height: 300.0)
    }
}
