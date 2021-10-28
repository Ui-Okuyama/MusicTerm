//
//  ViewController.swift
//  MusicTermApp
//
//  Created by 奥山羽衣　on 2021/08/22.
//

import UIKit
import Firebase
import RealmSwift
import AVFoundation

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var user: User?
    var SEAudioPlayer: AVAudioPlayer?
    var SEAudioPlayer2: AVAudioPlayer?
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
    @IBAction func TappedSettingButton(_ sender: Any) {
        presentToSettingViewController()
        SEManage.shared.playSE(resource: "SE_pupo")
    }
    @IBAction func tappedStartButton(_ sender: Any) {
        presentToHomeViewController()
        SEManage.shared.playSE(resource: "ボタン決定音")
    }
    
//MARK: -ライフサイクル
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        SoundManage.shared.playBgm(resource: "BeethovenPop")
        self.signInFirebaseAnonymouslyUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

//MARK: -レイアウトセットアップ
    private func setupViews() {
        let icon = UIImage(systemName: "gearshape.fill")
        settingButton.setImage(icon, for: .normal)
        settingButton.imageView?.contentMode = .scaleAspectFit
        settingButton.contentHorizontalAlignment = .fill
        settingButton.contentVerticalAlignment = .fill
        startButton.layer.cornerRadius = 15
    }
   
//MARK: -画面遷移
    private func presentToHomeViewController() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
        homeViewController.user = user
        navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    private func presentToSettingViewController() {
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let settingViewController = storyboard.instantiateViewController(identifier: "SettingViewController") as! SettingViewController
        present(settingViewController, animated: true, completion: nil)
    }
//MARK: -Firebase
    private func signInFirebaseAnonymouslyUser() {
        Auth.auth().signInAnonymously() { (authResult, error) in
            if error != nil {
                print("Auth Error :\(error!.localizedDescription)")
            }
            // 認証情報の取得
            guard let user = authResult?.user else { return }
            _ = user.isAnonymous  // true
            UserDefaults.standard.set(user.uid, forKey: "uid")
            print(UserDefaults.standard.string(forKey: "uid")!)
            self.fetchUserInfoFromFirebase()
        }
    }
    //ユーザー認証
    private func fetchUserInfoFromFirebase() {
        let userRef = Firestore.firestore().collection("users").document(UserDefaults.standard.string(forKey: "uid")!)
        userRef.getDocument { (document, err) in
            if let document = document, document.exists {
                guard let data = document.data() else { return }
                print(UserDefaults.standard.string(forKey: "uid")!)
                self.user = User.init(dic: data)
            } else {
                print("データなし新規作成へ")
                self.addNewUserInfoToFirebase(userRef: userRef)
            }
        }
    }
    //新規ユーザー登録
    private func addNewUserInfoToFirebase(userRef: DocumentReference) {
        let newData = ["name": "ナナシさん", "totalScore": 0, "bestScore": 0, "level": "はじめまして！", "currentImage": "Mozart", "images": ["Mozart", "J.S.Bach", "Beethoven", "Debussy", "Tchaikovsky", "Chopin"]] as [String : Any]
        userRef.setData(newData){(err) in
            if let err = err {
                print("Firestoreへの保存に失敗しました。\(err)")
            }
        return
        }
        user = User.init(dic: newData)
        //音量初期値セット
        UserDefaults.standard.setValue(1.0, forKey: "bgmVolume")
        SoundManage.shared.audioPlayer?.volume = 1.0
        UserDefaults.standard.setValue(1.0, forKey: "soundEffectVolume")
        
    }
}

