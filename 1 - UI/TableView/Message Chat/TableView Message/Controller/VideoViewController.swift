//
//  VideoViewController.swift
//  TableView Message
//
//  Created by Hoang Tung Lam on 2/1/21.
//

import UIKit
import AVKit
import Player

class VideoViewController: UIViewController {
    @IBOutlet weak var btnDismiss: UIButton!
    @IBOutlet weak var viewVideo: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    
    var isPlaying = false
    let player = Player()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.player.playbackDelegate = self
        self.player.view.frame = viewVideo.bounds
        viewVideo.addSubview(player.view)
//        self.addChild(player)
        player.didMove(toParent: self)
        player.url = URL(string: "https://storage.googleapis.com/coverr-main/mp4/Mt_Baker.mp4")!
        progressView.progress = 0
        viewVideo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapView)))
        player.fillMode = .resizeAspectFill
        player.autoplay = false
        
    }
    
    @objc func tapView() {
        self.isPlaying = !self.isPlaying
        
        if isPlaying {
            self.player.playFromCurrentTime()
        } else {
            self.player.pause()
        }
    }
    
    @IBAction func btnDismissTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension VideoViewController: PlayerPlaybackDelegate {
    func playerCurrentTimeDidChange(_ player: Player) {
        print(Double(player.maximumDuration))
        let fraction = Double(player.currentTime.seconds) / Double(player.maximumDuration)
        self.progressView.progress = Float(fraction)
    }
    
    func playerPlaybackWillStartFromBeginning(_ player: Player) {
    }
    
    func playerPlaybackDidEnd(_ player: Player) {
        self.isPlaying = false
    }
    
    func playerPlaybackWillLoop(_ player: Player) {
        self.progressView.progress = 0
    }
    
    func playerPlaybackDidLoop(_ player: Player) {
    }
}
