//
//  FirstShopperWelcomeVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 4/13/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import AVFoundation

class AVPlayerView: UIView {
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}
class FirstShopperWelcomeVC: UIViewController, WelcomeModel, IndexProviding {
    var index: Int = 0
    weak var delegate: WelcomeButtonActionsDelegate?
    @IBOutlet weak var videoView: AVPlayerView!
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadVideo()
    }

    func loadVideo() {
        let url = Bundle.main.url(forResource: "now_01", withExtension: "mp4")
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
        delegate?.nextButtonTapped()
    }
    @IBAction func skipButtonTapped(_ sender: Any) {
        delegate?.skipButtonTapped()
    }

}
