//
//  LandingViewController.swift
//  Sozie
//
//  Created by Danial Zahid on 17/12/2018.
//  Copyright © 2018 Danial Zahid. All rights reserved.
//

import UIKit
import AVFoundation

public enum UserType: String {
    case sozie = "SZ"
    case shopper = "SP"
}

class LandingViewController: UIViewController {

    @IBOutlet weak var sozieButton: DZGradientButton!
    @IBOutlet weak var shopperButton: UIButton!
    @IBOutlet weak var shopperLabel: UILabel!
    @IBOutlet weak var sozieLabel: UILabel!
    var currentUserType: UserType?
    var signUpDict: [String: Any] = [:]
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        sozieButton.shadowAdded = true
        sozieButton.layer.borderWidth = 0.5
        sozieButton.layer.borderColor = UIColor(hex: "979797").cgColor
        shopperButton.layer.cornerRadius = 6.0
        shopperButton.layer.borderWidth = 0.5
        shopperButton.layer.borderColor = UIColor(hex: "979797").cgColor
        loadBackgroundVideo()
        shopperLabel.lblShadow(color: UIColor.black, radius: 5, opacity: 0.84)
        sozieLabel.lblShadow(color: UIColor.black, radius: 5, opacity: 0.84)

    }
    func loadBackgroundVideo() {
        let url = Bundle.main.url(forResource: "signup", withExtension: "mp4")
        avPlayer = AVPlayer(url: url!)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avPlayer.volume = 0
        avPlayer.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
        avPlayerLayer.frame = view.layer.bounds
        view.backgroundColor = UIColor.clear
        view.layer.insertSublayer(avPlayerLayer, at: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)
        avPlayer.play()
    }
    @objc func playerItemDidReachEnd() {
        avPlayer.seek(to: CMTime.zero)
        avPlayer.play()
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if var signUpInfoProvider = segue.destination as? SignUpInfoProvider {
            signUpInfoProvider.signUpInfo = signUpDict
        }
        if var destVC = segue.destination as? WelcomeRootVC {
            destVC.userType = currentUserType
        }
//        if segue.identifier == "toCountryVC", let selectCountryViewController = segue.destination as? SelectCountryVC {
//            selectCountryViewController.currentUserType = currentUserType
//        }
    }

    @IBAction func signupShopperBtnTapped(_ sender: Any) {
        currentUserType = .shopper
        signUpDict[User.CodingKeys.country.stringValue] = 2
        signUpDict[User.CodingKeys.type.stringValue] = currentUserType?.rawValue
//        performSegue(withIdentifier: "toSignUpEmailVC", sender: self)
        performSegue(withIdentifier: "toWelcome", sender: self)
    }

    @IBAction func signUpSozieBtnTapped(_ sender: Any) {
        currentUserType = .sozie
        signUpDict[User.CodingKeys.country.stringValue] = 2
        signUpDict[User.CodingKeys.type.stringValue] = currentUserType?.rawValue
//        performSegue(withIdentifier: "toWorkVC", sender: self)
        performSegue(withIdentifier: "toWelcome", sender: self)

//        performSegue(withIdentifier: "toCountryVC", sender: self)
    }

}
