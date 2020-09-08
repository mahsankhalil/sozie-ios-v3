//
//  FirstSozieWelcomeVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 4/13/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import AVFoundation

class FirstSozieWelcomeVC: UIViewController, WelcomeModel, IndexProviding {

    weak var delegate: WelcomeButtonActionsDelegate?
    var index: Int = 1

    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var videoView: AVPlayerView!
    @IBOutlet weak var detailLabel: UILabel!
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    override func viewDidLoad() {
        super.viewDidLoad()

//         Do any additional setup after loading the view.
        let formattedString = NSMutableAttributedString()
        formattedString.normal("Fill ").bold("Requests ").normal("for Try-Ons.\nYou get paid for each approved request.\nCheck your updated ").bold("Balance ").normal("on your ").bold("Profile ").normal("page to see the money you’ve made!")
        detailLabel.attributedText = formattedString
        loadVideo()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let linkedWith = appDelegate.codeLinkedWith {
            if linkedWith == "brand" {
                detailLabel.text = ""
                let formattedString = NSMutableAttributedString()
                formattedString.normal("Sozie ").bold("Requests", size: 28.0)
                titleLabel.attributedText = formattedString
                bottomViewHeightConstraint.constant = 203
            }
        }
    }
    func loadVideo() {
        let url = Bundle.main.url(forResource: "now_02", withExtension: "mp4")
        avPlayer = AVPlayer(url: url!)
        avPlayerLayer = (videoView.layer as! AVPlayerLayer)
        avPlayerLayer.player = avPlayer
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        avPlayer.volume = 0
        avPlayer.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
        videoView.backgroundColor = UIColor.clear
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)
        avPlayer.play()
    }
    @objc func playerItemDidReachEnd() {
        avPlayer.seek(to: CMTime.zero)
        avPlayer.play()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func nextButtonTapped(_ sender: Any) {
        delegate?.shopTogetherButtonTapped()
//        delegate?.nextButtonTapped()
    }
    @IBAction func skipButtonTapped(_ sender: Any) {
        delegate?.skipButtonTapped()
    }

}
