//
//  ResultViewController.swift
//  MusicTermApp
//
//  Created by 槙和馬 on 2021/09/04.
//

import Foundation
import Firebase
import RealmSwift
import GoogleMobileAds

class ResultViewController: UIViewController {
    
    var score: Int?
    var user: User?
    var level: Level?
    var newTotalScore: Int?
    var newLevelText: String?
    let userRef = Firestore.firestore().collection("users").document(UserDefaults.standard.string(forKey: "uid")!)
    
    @IBOutlet weak var viewTitleLabel: UILabel!
    @IBOutlet weak var composerImage: UIImageView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var scoreTitleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var bestscoreLabel: UILabel!
    @IBOutlet weak var totalscoreLabel: UILabel!
    @IBOutlet weak var toHomeButton: UIButton!
    @IBOutlet weak var toListOfTerm: UIButton!
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBAction func tappedHomeButton(_ sender: Any) {
        presentToHomeViewController()
    }
    @IBAction func tappedListOfTerm(_ sender: Any) {
        presentToListViewController()
    }
//MARK: -ライフサイクル
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupBanner()
        fetchUserInfoFromFirebase { (user) in
            self.setupWithUserdata()
            self.judgeLevelUp()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        labelAndButtonResize()
    }
    
//MARK: -レイアウトセットアップ
    private func setup() {
        commentView.layer.cornerRadius = 30
        toHomeButton.layer.cornerRadius = 15
        toListOfTerm.layer.cornerRadius = 15
        scoreLabel.text = String(score!)
    }
    
    private func setupWithUserdata() {
        if score! > (user?.bestScore)! {
            bestscoreLabel.text = "ベストスコア: \(score!)"
            updateBestScoreFirestoreData()
        } else {
            bestscoreLabel.text = "ベストスコア: \((user?.bestScore)!)"
        }
        newTotalScore = (user?.totalScore)! + score!
        if newTotalScore! >= 100000000 {
            totalscoreLabel.text = "総スコア: 99999999"
            newTotalScore = 99999999
        } else {
            totalscoreLabel.text = "総スコア: \(newTotalScore!)"
        }
        updateTotalScoreFirestoreData()
        composerImage.image = UIImage(named: (user?.currentImage)!)
    }
    
    private func labelAndButtonResize() {
        let vHeight = view.bounds.height
        viewTitleLabel.font = viewTitleLabel.font.withSize( vHeight / 30 )
        viewTitleLabel.sizeToFit()
        commentLabel.font = commentLabel.font.withSize( vHeight /  40 )
        scoreTitleLabel.font = scoreTitleLabel.font.withSize( vHeight / 42 )
        bestscoreLabel.font = bestscoreLabel.font.withSize( vHeight / 42 )
        totalscoreLabel.font = totalscoreLabel.font.withSize( vHeight / 42 )
        scoreLabel.font = scoreLabel.font.withSize( vHeight / 13 )
        let fontsize = Int(toHomeButton.frame.size.height / 2.5)
        toHomeButton.titleLabel?.font = UIFont(name: "JK-Maru-Gothic-M", size: CGFloat(fontsize))
        toListOfTerm.titleLabel?.font = UIFont(name: "JK-Maru-Gothic-M", size: CGFloat(fontsize))
    }
    
    private func setupBanner() {
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }

//MARK: -Firebase
    private func fetchUserInfoFromFirebase(comletion: @escaping (User) -> Void) {
        let userRef = Firestore.firestore().collection("users").document(UserDefaults.standard.string(forKey: "uid")!)
        userRef.getDocument { [self] (document, err) in
            if let err = err {
                print("ユーザー情報の取得に失敗しました。\(err)")
            }
            guard let data = document!.data() else { return }
            self.user = User.init(dic: data)
            comletion(self.user!)
        }
    }
    
    private func judgeLevelUp() {
        print(user!.level)
        level = Level.init(level: user!.level)
        if level!.jugdeNextLevel(totalScore: newTotalScore!) {
            newLevelText = level!.nextLevelName()
            presentToLevelUpViewController()
            updateLevelFirestoreData()
        } else {
            print("no levelup")
        }
    }
 //MARK: -Firestoreのデータの更新
    private func updateLevelFirestoreData() {
        userRef.updateData(["level" : newLevelText!]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            }
        }
    }
    
    private func updateTotalScoreFirestoreData() {
        userRef.updateData(["totalScore" : newTotalScore!]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            }
        }
    }
    
    private func updateBestScoreFirestoreData() {
        userRef.updateData(["bestScore" : score!]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            }
        }
    }
 //MARK: - 画面遷移
    private func presentToHomeViewController() {
        navigationController?.popToViewController(navigationController!.viewControllers[1], animated: true)
    }
    
    private func presentToListViewController() {
        let storyboard = UIStoryboard(name: "List", bundle: nil)
        let listViewController = storyboard.instantiateViewController(identifier: "ListViewController") as! ListViewController
        navigationController?.pushViewController(listViewController, animated: true)
    }
    
    private func presentToLevelUpViewController() {
        let levelUpViewController = storyboard?.instantiateViewController(identifier: "LevelUpViewController") as! LevelUpViewController
        levelUpViewController.presentationController?.delegate = self
        levelUpViewController.level = level
        levelUpViewController.levelText = newLevelText
        present(levelUpViewController, animated: true, completion: nil)
    }
}

//MARK: -extension
extension ResultViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        fetchUserInfoFromFirebase { user in
            self.judgeLevelUp()
        }
    }
}
