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
    var newTotalScore: Int?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupBanner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUserInfoFromFirebase()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        labelAndButtonResize()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateFirestoreData()
    }
    
    func setup() {
        commentView.layer.cornerRadius = 30
        toHomeButton.layer.cornerRadius = 15
        toListOfTerm.layer.cornerRadius = 15
        scoreLabel.text = String(score!)
    }
    
    func setupWithUserdata() {
        if score! > (user?.bestScore)! {
            bestscoreLabel.text = "ベストスコア: \(score!)"
        } else {
            bestscoreLabel.text = "ベストスコア: \((user?.bestScore)!)"
        }
        newTotalScore = (user?.totalScore)! + score!
        totalscoreLabel.text = "総スコア: \(newTotalScore!)"
        composerImage.image = UIImage(named: (user?.currentImage)!)
    }
    
    func labelAndButtonResize() {
        let vHeight = view.bounds.height
        viewTitleLabel.font = viewTitleLabel.font.withSize( vHeight / 30 )
        viewTitleLabel.sizeToFit()
        commentLabel.font = commentLabel.font.withSize( vHeight /  40 )
        scoreTitleLabel.font = scoreTitleLabel.font.withSize( vHeight / 42 )
        bestscoreLabel.font = bestscoreLabel.font.withSize( vHeight / 42 )
        totalscoreLabel.font = totalscoreLabel.font.withSize( vHeight / 42 )
        scoreLabel.font = scoreLabel.font.withSize( vHeight / 13 )
        let fontsize = Int(toHomeButton.frame.size.height / 2.5)
        toHomeButton.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(fontsize))
        toListOfTerm.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(fontsize))
    }
    
    private func setupBanner() {
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    private func fetchUserInfoFromFirebase() {
        let userRef = Firestore.firestore().collection("users").document(UserDefaults.standard.string(forKey: "uid")!)
        userRef.getDocument { [self] (document, err) in
            if let err = err {
                print("ユーザー情報の取得に失敗しました。\(err)")
            }
            guard let data = document!.data() else { return }
            self.user = User.init(dic: data)
            setupWithUserdata()
        }
    }
    
    private func updateFirestoreData() {
        let userRef = Firestore.firestore().collection("users").document(UserDefaults.standard.string(forKey: "uid")!)
        userRef.updateData(["totalScore" : newTotalScore!]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    private func presentToHomeViewController() {
        navigationController?.popToViewController(navigationController!.viewControllers[1], animated: true)
    }
    
    private func presentToListViewController() {
        let storyboard = UIStoryboard(name: "List", bundle: nil)
        let listViewController = storyboard.instantiateViewController(identifier: "ListViewController") as! ListViewController
        navigationController?.pushViewController(listViewController, animated: true)
    }
}
