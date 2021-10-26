//
//  ChatVideoMeCell.swift
//  TableView Message
//
//  Created by Hoang Tung Lam on 1/29/21.
//

import UIKit
import Player

class ChatVideoMeCell: UITableViewCell {
    @IBOutlet weak var viewVideo: UIView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnExtend: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    
    weak var delegate: ChatVideoDelegate?
    
    //    var avPlayer: AVPlayer?
    let player = Player()
    
    var isPlayingVideo = false
    var url = ""
    
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
        viewVideo.layer.cornerRadius = 10
        viewVideo.layer.borderWidth = 0.5
        viewVideo.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        viewVideo.layer.masksToBounds = true
        btnPlay.layer.cornerRadius = btnPlay.frame.height / 2
        btnPlay.layer.borderWidth = 0.5
        btnPlay.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    @objc func tapView() {
        btnPlay.alpha = 1
        btnExtend.alpha = 1
    }
    
    @IBAction func btnPlayTapped(_ sender: Any) {
        self.isPlayingVideo = !self.isPlayingVideo
        if isPlayingVideo {
            self.player.playFromCurrentTime()
            btnPlay.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
            UIView.animate(withDuration: 2) {
                self.btnPlay.alpha = 0
                self.btnExtend.alpha = 0
            }
        } else {
            self.player.pause()
            btnPlay.setImage(UIImage(systemName: "play.fill"), for: .normal)
            btnPlay.alpha = 1
            btnExtend.alpha = 1
        }
    }
    @IBAction func btnExtendTapped(_ sender: Any) {
        player.pause()
        self.isPlayingVideo = false
        btnPlay.setImage(UIImage(systemName: "play.fill"), for: .normal)
        delegate?.moveData(video: self.url)
    }
}

extension ChatVideoMeCell {
    /// - setup video không dùng thư viện
    //    func setUpVideo(video: String) {
    //        let url = URL(string: video)!
    //        avPlayer = AVPlayer(url: url)
    //        let avPlayerLayer = AVPlayerLayer(player: avPlayer)
    //        avPlayerLayer.videoGravity = .resizeAspect
    //        avPlayer?.volume = 3
    //        avPlayer?.actionAtItemEnd = .none
    //        avPlayerLayer.frame = viewVideo.bounds
    //        self.viewVideo.layer.insertSublayer(avPlayerLayer, at: 0)
    //        avPlayer?.usesExternalPlaybackWhileExternalScreenIsActive = true
    //    }
    
    func setUpVideo(video: String) {
        player.url = URL(string: video)!
        self.player.playbackDelegate = self
        player.fillMode = .resizeAspectFill
        player.autoplay = false
        player.volume = 10
        self.player.view.frame = viewVideo.bounds
        viewVideo.addSubview(player.view)
        viewVideo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapView)))
    }
    
    func setUpData(video: String) {
        self.url = video
        setUpVideo(video: video)
    }
}

extension ChatVideoMeCell: PlayerPlaybackDelegate {
    func playerCurrentTimeDidChange(_ player: Player) {
        let fraction = Double(player.currentTime.seconds) / Double(player.maximumDuration)
        self.progressView.progress = Float(fraction)
    }
    
    func playerPlaybackWillStartFromBeginning(_ player: Player) {
    }
    
    func playerPlaybackDidEnd(_ player: Player) {
        self.isPlayingVideo = false
        btnPlay.setImage(UIImage(systemName: "play.fill"), for: .normal)
    }
    
    func playerPlaybackWillLoop(_ player: Player) {
        self.progressView.progress = 0
    }
    
    func playerPlaybackDidLoop(_ player: Player) {
    }
}
