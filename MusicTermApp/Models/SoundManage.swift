//
//  SoundManage.swift
//  MusicTermApp
//
//  Created by 槙和馬 on 2021/10/18.
//

import Foundation
import AVFoundation

class SoundManage {
    
    static let shared = SoundManage()
    var audioPlayer: AVAudioPlayer?
    
    func playBgm(resource: String) {
        do {
            let filePath = Bundle.main.path(forResource: resource, ofType: "mp3")
            let musicPath = URL(fileURLWithPath: filePath!)
            audioPlayer = try AVAudioPlayer(contentsOf: musicPath)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.volume = UserDefaults.standard.float(forKey: "bgmVolume")
            audioPlayer?.play()
        } catch {
            print("audio error")
        }
    }
    
    func stopBgm() {
        audioPlayer?.stop()
    }
}
