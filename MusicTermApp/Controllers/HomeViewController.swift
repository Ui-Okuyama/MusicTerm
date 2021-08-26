//
//  HomeViewController.swift
//  MusicTermApp
//
//  Created by 槙和馬 on 2021/08/22.
//

import Foundation
import UIKit
import Firebase

class HomeViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var user: User?
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var bestScoreLabel: UILabel!
    @IBOutlet weak var difficultyButton1: UIButton!
    @IBOutlet weak var difficultyButton2: UIButton!
    @IBOutlet weak var difficultyButton3: UIButton!
    @IBOutlet weak var difficultyButton4: UIButton!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var levelBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHomeViews()
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedProfileView(_:)))
        self.profileView.addGestureRecognizer(tapGesture)
            
        tapGesture.delegate = self
            }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        fetchUserInfoFromFirebase()
    }
    
    private func fetchUserInfoFromFirebase() {
        let userRef = Firestore.firestore().collection("users").document(UserDefaults.standard.string(forKey: "uid")!)
        userRef.getDocument { [self] (document, err) in
            if let err = err {
                print("ユーザー情報の取得に失敗しました。\(err)")
            }
            guard let data = document!.data() else { return }
            self.user = User.init(dic: data)
            userName.text = user?.name
            levelLabel.text = user?.level
            totalScoreLabel.text = "総スコア：" + String(user!.totalScore)
            bestScoreLabel.text = "ベストスコア：" + String(user!.bestScore)
            print(self.user!.name)
        }
    }
    
    private func setupHomeViews() {
        self.view.sendSubviewToBack(profileView)
        print("setup")
        
        difficultyButton1.layer.cornerRadius = 20
        difficultyButton2.layer.cornerRadius = 20
        difficultyButton3.layer.cornerRadius = 20
        difficultyButton4.layer.cornerRadius = 20
    }
    
    @objc func tappedProfileView(_ sender: UITapGestureRecognizer) {
        let storyBoard = UIStoryboard(name: "ProfileEdit", bundle: nil)
        let profileEditController = storyBoard.instantiateViewController(identifier: "ProfileEditController") as! ProfileEditController
        profileEditController.modalPresentationStyle = .fullScreen
        profileEditController.user = user
        navigationController?.pushViewController(profileEditController, animated: true)
    }
    
    
        
   
}
