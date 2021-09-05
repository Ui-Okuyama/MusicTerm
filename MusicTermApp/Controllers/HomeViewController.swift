//
//  HomeViewController.swift
//  MusicTermApp
//
//  Created by 槙和馬 on 2021/08/22.
//

import Foundation
import UIKit
import Firebase
import GoogleMobileAds

class HomeViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var user: User?
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var bestScoreLabel: UILabel!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var difficultyButton1: UIButton!
    @IBOutlet weak var difficultyButton2: UIButton!
    @IBOutlet weak var difficultyButton3: UIButton!
    @IBOutlet weak var difficultyButton4: UIButton!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var levelBar: UIProgressView!
    @IBOutlet weak var toListOfTermButton: UIButton!
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBAction func tappedDifficultyButton1(_ sender: Any) {
        presentToCountdownView(quizdata: "quizdataEasy")
    }
    @IBAction func tappedDifficultyButton2(_ sender: Any) {
        presentToCountdownView(quizdata: "quizdataNormal")
    }
    @IBAction func tappedDifficultyButton3(_ sender: Any) {
        presentToCountdownView(quizdata: "quizdataHard")
    }
    @IBAction func tappedDifficultyButton4(_ sender: Any) {
        presentToCountdownView(quizdata: "quizdataLunatic")
    }
    @IBAction func tappedToListButton(_ sender: Any) {
        presentToListOfTermViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHomeViews()
        setupBanner()
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedProfileView(_:)))
        self.profileView.addGestureRecognizer(tapGesture)
            
        tapGesture.delegate = self
            }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        fetchUserInfoFromFirebase()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        labelAndButtonResize()
    }
    
    private func setupHomeViews() {
        self.view.sendSubviewToBack(profileView)
        buttonLayout(button: difficultyButton1)
        buttonLayout(button: difficultyButton2)
        buttonLayout(button: difficultyButton3)
        buttonLayout(button: difficultyButton4)
    }
    
    private func setupBanner() {
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    private func buttonLayout(button: UIButton) {
        button.layer.cornerRadius = 20
        button.titleLabel?.adjustsFontSizeToFitWidth = true
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
            profileImage.image = UIImage(named: user!.currentImage)
            UserDefaults.standard.set(user?.images, forKey: "images")
            print(self.user!.name)
        }
    }
    
    @objc func tappedProfileView(_ sender: UITapGestureRecognizer) {
        let storyBoard = UIStoryboard(name: "ProfileEdit", bundle: nil)
        let profileEditController = storyBoard.instantiateViewController(identifier: "ProfileEditController") as! ProfileEditController
        profileEditController.modalPresentationStyle = .fullScreen
        profileEditController.user = user
        navigationController?.pushViewController(profileEditController, animated: true)
    }
    
    private func labelAndButtonResize() {
        let vHeight = self.view.bounds.height
        userName.font = userName.font.withSize(vHeight / 29)
        levelLabel.font = levelLabel.font.withSize(vHeight / 37)
        bestScoreLabel.font = bestScoreLabel.font.withSize(vHeight / 60)
        totalScoreLabel.font = totalScoreLabel.font.withSize(vHeight / 60)
        level.font = level.font.withSize(vHeight / 60)
        let fontsize = Int(difficultyButton1.frame.size.height) / 2
        difficultyButton1.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(fontsize))
        difficultyButton2.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(fontsize))
        difficultyButton3.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(fontsize))
        difficultyButton4.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(fontsize))
    }
    
    private func presentToCountdownView(quizdata: String) {
            let storyBoard = UIStoryboard(name: "Countdown", bundle: nil)
            let countdownViewController = storyBoard.instantiateViewController(identifier: "CountdownViewController") as! CountdownViewController
            countdownViewController.quizdata = quizdata
            navigationController?.pushViewController(countdownViewController, animated: true)
    }
    
    private func presentToListOfTermViewController() {
        let storyboard = UIStoryboard(name: "TermOfList", bundle: nil)
        let termOfListViewController = storyboard.instantiateViewController(identifier: "TermOfListViewController") as! TermOfListViewController
        navigationController?.pushViewController(termOfListViewController, animated: true)
    }
}
