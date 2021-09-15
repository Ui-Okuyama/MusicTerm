//
//  ViewController.swift
//  MusicTermApp
//
//  Created by 槙和馬 on 2021/08/22.
//

import UIKit
import Firebase
import RealmSwift

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var user: User?
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
    @IBAction func TappedSettingButton(_ sender: Any) {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        let test = realm.objects(AnswerLog.self)
        print(test)
    }
    
    @IBAction func touchdownStartButton(_ sender: Any) {
        changeColorButton()
    }
    @IBAction func tappedStartButton(_ sender: Any) {
        presentToHomeViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.signInFirebaseAnonymouslyUser()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    private func setupViews() {
        let icon = UIImage(systemName: "gearshape.fill")
        settingButton.setImage(icon, for: .normal)
        startButton.layer.cornerRadius = 15
    }
    
    private func presentToHomeViewController() {
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController = storyBoard.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
        homeViewController.user = user
        navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    private func changeColorButton() {
        startButton.backgroundColor = UIColor.rgb(red: 161, green: 101, blue: 74, alpha: 1)
    }
    
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
    
    private func addNewUserInfoToFirebase(userRef: DocumentReference) {
        let newData = ["name": "ナナシさん", "totalScore": 0, "bestScore": 0, "level": "かけだし", "currentImage": "Mozart", "images": ["Mozart", "J.S.Bach", "Beethoven", "Debussy", "Tchaikovsky", "Chopin"]] as [String : Any]
        userRef.setData(newData){(err) in
            if let err = err {
                print("Firestoreへの保存に失敗しました。\(err)")
            }
        return
        }
        user = User.init(dic: newData)
        print(user!.name)
    }
}

