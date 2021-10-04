//
//  SettingViewController.swift
//  MusicTermApp
//
//  Created by 槙和馬 on 2021/10/02.
//

import Foundation
import UIKit
class SettingViewController : UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var BGMSlider: UISlider!
    @IBOutlet weak var soundEffectSlider: UISlider!
    
    @IBAction func touchUpBGMSlider(_ sender: UISlider) {
        let volume = Float( round(sender.value * 10) / 10 ) // 小数第一位まで
        UserDefaults.standard.setValue(volume,forKey: "bgmVolume")
    }
    @IBAction func touchUpSoundEffect(_ sender: UISlider) {
        let volume = Float( round(sender.value * 10) / 10 ) // 小数第一位まで
        UserDefaults.standard.setValue(volume,forKey: "soundEffectVolume")
    }
    @IBAction func tappedSettingButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
        BGMSlider.value = UserDefaults.standard.float(forKey: "bgmVolume")
        soundEffectSlider.value = UserDefaults.standard.float(forKey: "soundEffectVolume")
    }
}
