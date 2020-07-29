//
//  ReferralPopupVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 5/4/20.
//  Copyright © 2020 Danial Zahid. All rights reserved.
//

import UIKit

class ReferralPopupVC: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var gotitButton: DZGradientButton!
    var closeHandler: (() -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    class func instance() -> ReferralPopupVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let instnce = storyboard.instantiateViewController(withIdentifier: "ReferralPopupVC") as! ReferralPopupVC
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

    @IBAction func closeButtonTapped(_ sender: Any) {
        closeHandler!()
    }
    @IBAction func gotItButtonTapped(_ sender: Any) {
        closeHandler!()
    }
}
extension ReferralPopupVC: PopupContentViewController {
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width - 26.0, height: 270.0)
    }
}
