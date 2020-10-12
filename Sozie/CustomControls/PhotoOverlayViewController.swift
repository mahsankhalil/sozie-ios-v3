//
//  PhotoOverlayViewController.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 10/12/20.
//  Copyright © 2020 Danial Zahid. All rights reserved.
//

import UIKit

class PhotoOverlayViewController: UIViewController {
    @IBOutlet weak var poseButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        poseButton.addTarget(self, action: #selector(strikePoseButtonTapped(_:)), for: .touchUpInside)
    }

    @objc func strikePoseButtonTapped(_ sender: Any) {
        let popUpInstnc = PosePopupVC.instance(photoIndex: 0)
        let popUpVC = PopupController
            .create(self.parent!)
            .show(popUpInstnc)
        let options = PopupCustomOption.layout(.top)
        _ = popUpVC.customize([options])
        popUpVC.updatePopUpSize()
        popUpInstnc.closeHandler = { []  in
            popUpVC.dismiss()
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

}
