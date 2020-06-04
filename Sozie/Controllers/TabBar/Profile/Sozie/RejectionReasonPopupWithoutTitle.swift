//
//  RejectionReasonPopupWithoutTitle.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 6/4/20.
//  Copyright © 2020 Danial Zahid. All rights reserved.
//

import UIKit

class RejectionReasonPopupWithoutTitle: UIViewController {

    @IBOutlet weak var tryAgainButton: DZGradientButton!
    @IBOutlet weak var userLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let user = UserDefaultManager.getCurrentUserObject() {
            if let name = user.firstName {
                userLabel.text = "Hi " + name
            }
        }
    }
    
    class func instance() -> RejectionReasonPopupWithoutTitle {
        let storyBoard = UIStoryboard(name: "TabBar", bundle: .main)
        return storyBoard.instantiateViewController(withIdentifier: "RejectionReasonPopupWithoutTitle") as! RejectionReasonPopupWithoutTitle
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func tryAgainButtonTapped(_ sender: Any) {
    }
    
}
extension RejectionReasonPopupWithoutTitle: PopupContentViewController {
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width - 26.0, height: 200)
    }
}
