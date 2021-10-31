//
//  SettingViewController.swift
//  MusicTermApp
//
//  Created by 槙和馬 on 2021/10/02.
//

import Foundation
import UIKit
import SafariServices

class SettingViewController : UIViewController {
    
    let appID = ""
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var privacyPolicyButton: UIButton!
    @IBOutlet weak var BGMSlider: UISlider!
    @IBOutlet weak var soundEffectSlider: UISlider!
    
    @IBAction func touchUpBGMSlider(_ sender: UISlider) {
        let volume = Float( round(sender.value * 10) / 10 ) // 小数第一位まで
        UserDefaults.standard.setValue(volume,forKey: "bgmVolume")
        SoundManage.shared.audioPlayer?.volume = volume
    }
    @IBAction func touchUpSoundEffect(_ sender: UISlider) {
        let volume = Float( round(sender.value * 10) / 10 ) // 小数第一位まで
        UserDefaults.standard.setValue(volume,forKey: "soundEffectVolume")
    }
    @IBAction func tappedSettingButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        SEManage.shared.playSE(resource: "SE_pupo")
    }
    @IBAction func tappedReviewButton(_ sender: Any) {
        let url = URL(string: "https://itunes.apple.com/jp/app/id\(appID)")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    @IBAction func tappedTwitterButton(_ sender: Any) {
        let url = URL(string: "https://twitter.com/U_Okuyama_Devlp")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    @IBAction func tappedPrivacyButton(_ sender: Any) {
        let url = URL(string: "https://musictermapp.web.app/")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        closeButton.imageView?.contentMode = .scaleAspectFit
        closeButton.contentHorizontalAlignment = .fill
        closeButton.contentVerticalAlignment = .fill
        reviewButton.layer.cornerRadius = 10
        twitterButton.layer.cornerRadius = 10
        privacyPolicyButton.layer.cornerRadius = 10
        BGMSlider.value = UserDefaults.standard.float(forKey: "bgmVolume")
        soundEffectSlider.value = UserDefaults.standard.float(forKey: "soundEffectVolume")
    }
}
