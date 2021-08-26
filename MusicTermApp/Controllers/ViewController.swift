//
//  ViewController.swift
//  MusicTermApp
//
//  Created by 槙和馬 on 2021/08/22.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    var user: User?
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
    @IBAction func TappedSettingButton(_ sender: Any) {
    }
    
    @IBAction func touchdownStartButton(_ sender: Any) {
        startButton.backgroundColor = UIColor.rgb(red: 200, green: 108, blue: 0, alpha: 1)
    }
    @IBAction func tappedStartButton(_ sender: Any) {
        startButton.backgroundColor = UIColor.rgb(red: 255, green: 149, blue: 0, alpha: 1)
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

    private func setupViews() {
        startButton.layer.cornerRadius = 20
        let icon = UIImage(systemName: "gearshape.fill")
        settingButton.setImage(icon, for: .normal)
    }
    
    private func presentToHomeViewController() {
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController = storyBoard.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
        homeViewController.user = user
        navigationController?.pushViewController(homeViewController, animated: true)
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
        let newData = ["name": "ナナシさん", "totalScore": 0, "bestScore": 0, "level": "かけだし", "imageNumber": 1] as [String : Any]
        userRef.setData(newData){(err) in
            if let err = err {
                print("Firestoreへの保存に失敗しました。\(err)")
            }
        return
        }
        user = User.init(dic: newData)
    }
}

