//
//  SozieRequestErrorPopUp.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 8/22/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class SozieRequestErrorPopUp: UIViewController {

    @IBOutlet weak var restartButton: DZGradientButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    var descriptionText: String?
    var closeHandler: (() -> Void)?
    var resetTutorialHandler: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let user = UserDefaultManager.getCurrentUserObject() {
            if let firstName = user.firstName {
                nameLabel.text = "Hi " + firstName + ","
            }
        }
        descriptionLabel.text = descriptionText
    }
    class func instance(description: String) -> SozieRequestErrorPopUp {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let instnce = storyboard.instantiateViewController(withIdentifier: "SozieRequestErrorPopUp") as! SozieRequestErrorPopUp
        instnce.descriptionText = description
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
        self.closeHandler?()
    }
    @IBAction func restartTutorialButtonTapped(_ sender: Any) {
        self.resetTutorialHandler?()
    }
    
}
extension SozieRequestErrorPopUp: PopupContentViewController {
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width - 25.0, height: 370.0)
    }
}
