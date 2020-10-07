//
//  LandingViewController.swift
//  Sozie
//
//  Created by Danial Zahid on 17/12/2018.
//  Copyright © 2018 Danial Zahid. All rights reserved.
//

import UIKit
import AVFoundation

class LandingViewController: UIViewController {

    @IBOutlet weak var sozieButton: DZGradientButton!
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    private var signUpDict: [String: Any]?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        sozieButton.shadowAdded = true
        sozieButton.layer.borderWidth = 0.5
        sozieButton.layer.borderColor = UIColor(hex: "979797").cgColor
        loadBackgroundVideo()
    }
    func loadBackgroundVideo() {
        let url = Bundle.main.url(forResource: "SignupTrimmed", withExtension: "m4v")
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
    }
    @IBAction func signUpSozieBtnTapped(_ sender: Any) {
        signUpDict![User.CodingKeys.country.stringValue] = 2
        signUpDict![User.CodingKeys.type.stringValue] = "SZ"
        performSegue(withIdentifier: "toWelcome", sender: self)
    }

}
extension LandingViewController: SignUpInfoProvider {
    var signUpInfo: [String: Any]? {
        get { return signUpDict }
        set (newInfo) {
            signUpDict = newInfo
        }
    }
}
