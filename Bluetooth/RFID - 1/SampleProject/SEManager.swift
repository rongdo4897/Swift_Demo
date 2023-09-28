//
//  SEManager.swift
//  UF-2200Sample
//
//  Created by H.takagi[ASNO] on 2018/07/19.
//  Copyright © 2018年 TOSHIBA TEC CORPORATION. All rights reserved
//
////  サウンドを鳴らす制御するクラス

import Foundation
import AVFoundation
class SEManager: NSObject,AVAudioPlayerDelegate {
    var _soundVolume:Float
    var audioPlayer: AVAudioPlayer
    
    /** シングルトン */
    static let sharedManager = SEManager()
    
    private override init() {
        _soundVolume = 1.0
         audioPlayer = AVAudioPlayer()
    }
    
    /** 音を一回鳴らす */
    func playSound(soundName:String) {
        if let urlOfSound = Bundle.main.path(forResource: soundName, ofType: "mp3") {
            do {
                // AVAudioPlayerのインスタンス化
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlOfSound))
                audioPlayer.numberOfLoops = 0
                audioPlayer.volume = _soundVolume
                audioPlayer.delegate = self
                // 音声の再生
                audioPlayer.play()
            } catch {
                print("failed to playSound: \(error)")
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer,
                                     successfully flag: Bool) {
        print("audioPlayerDidFinishPlaying")
    }
}
