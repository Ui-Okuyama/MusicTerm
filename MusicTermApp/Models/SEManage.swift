//
//  SEManage.swift
//  MusicTermApp
//
//  Created by 槙和馬 on 2021/10/19.
//

import Foundation
import AVFoundation

class SEManage {
    
    static let shared = SEManage()
    var SEAudioPlayer: AVAudioPlayer?
    
    func playSE(resource: String) {
        do {
            let filePath = Bundle.main.path(forResource: resource, ofType: "mp3")
            let SEPath = URL(fileURLWithPath: filePath!)
            SEAudioPlayer = try AVAudioPlayer(contentsOf: SEPath)
            SEAudioPlayer?.volume = UserDefaults.standard.float(forKey: "soundEffectVolume")
            SEAudioPlayer?.prepareToPlay()
            SEAudioPlayer?.play()
        } catch {
            print("SE error")
        }
    }
}


