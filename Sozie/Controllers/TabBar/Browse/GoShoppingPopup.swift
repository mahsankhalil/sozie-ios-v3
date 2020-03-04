//
//  GoShoppingPopup.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 10/25/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class GoShoppingPopup: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
extension GoShoppingPopup: PopupContentViewController {
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width - 30.0, height: 155)
    }
}
