//
//  RejectionReasonPopup.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 6/4/20.
//  Copyright © 2020 Danial Zahid. All rights reserved.
//

import UIKit
protocol RejectionResponseDelegate: class {
    func tryAgainButtonTapped(button: UIButton, collectionViewTag: Int?, cellTag: Int?)
}
class RejectionReasonPopup: UIViewController {
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var tryAgainButton: DZGradientButton!
    weak var delegate: RejectionResponseDelegate?
    var reason: String?
    var collectionViewTag: Int?
    var cellTag: Int?
    var closeHandler: (() -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        reasonLabel.text = reason
        if let user = UserDefaultManager.getCurrentUserObject() {
            if let name = user.firstName {
                userLabel.text = "Hi " + name
            }
        }
    }
    class func instance(reason: String, collectionViewTag: Int, cellTag: Int) -> RejectionReasonPopup {
        let storyBoard = UIStoryboard(name: "TabBar", bundle: .main)
        let instance = storyBoard.instantiateViewController(withIdentifier: "RejectionReasonPopup") as! RejectionReasonPopup
        instance.reason = reason
        instance.collectionViewTag = collectionViewTag
        instance.cellTag = cellTag
        return instance
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
        self.closeHandler!()
        delegate?.tryAgainButtonTapped(button: sender as! UIButton, collectionViewTag: collectionViewTag, cellTag: cellTag)
    }
}
extension RejectionReasonPopup: PopupContentViewController {
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width - 26.0, height: 300)
    }
}
