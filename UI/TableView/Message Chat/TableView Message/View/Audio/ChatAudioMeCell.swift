//
//  ChatAudioMeCell.swift
//  TableView Message
//
//  Created by Hoang Tung Lam on 2/3/21.
//

import UIKit
import AVKit
import Player

class ChatAudioMeCell: UITableViewCell {
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var viewBackground: UIView!
    
    var player: AVPlayer?
    var isPlayingAudio = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        initComponent()
    }
    
    func initComponent() {
        customizeLayout()
        btnPlay.setImage(UIImage(systemName: "play.fill"), for: .normal)
        progressView.progress = 0
    }
    
    func customizeLayout() {
        btnPlay.layer.cornerRadius = btnPlay.frame.height / 2
        btnPlay.layer.borderWidth = 0.5
        btnPlay.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        progressView.layer.cornerRadius = 15
        progressView.clipsToBounds = true
        viewBackground.layer.borderWidth = 0.5
        viewBackground.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        viewBackground.layer.cornerRadius = viewBackground.frame.height / 2
    }
    
    @IBAction func btnPlayTapped(_ sender: Any) {
        self.isPlayingAudio = !self.isPlayingAudio
        if isPlayingAudio {
            self.player?.play()
            btnPlay.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        } else {
            self.player?.pause()
            btnPlay.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
}

extension ChatAudioMeCell {
    func setUpAudio(audio: String) {
        let audioURL = URL(string: audio)!
        let playerItem = AVPlayerItem(url: audioURL)
        player = AVPlayer(playerItem: playerItem)

        player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            if self.player!.currentItem?.status == .readyToPlay {
                let time : Float64 = CMTimeGetSeconds(self.player!.currentTime());
                let duration: Float64 = CMTimeGetSeconds(self.player!.currentItem?.duration ?? CMTime)
                if time != duration {
                    self.progressView.progress = Float(time / duration)
                } else {
                    self.player?.seek(to: CMTimeMake(value: 0, timescale: 1))
                    self.isPlayingAudio = false
                    self.btnPlay.setImage(UIImage(systemName: "play.fill"), for: .normal)
                    self.progressView.progress = 0
                }
            }
        }
    }
    
    func setUpData(audio: String) {
        setUpAudio(audio: audio)
    }
}
