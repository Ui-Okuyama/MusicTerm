//
//  ProfileEditController.swift
//  MusicTermApp
//
//  Created by 槙和馬 on 2021/08/23.
//

import Foundation
import UIKit
import Firebase

class ProfileEditController: UIViewController, UIGestureRecognizerDelegate {
    var user:User?
    var images:Array<String>?
    let maxLength = 10
    
    @IBOutlet weak var iconName: UILabel!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var totalscore: UILabel!
    @IBOutlet weak var bestscore: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var totalscoreLabel: UILabel!
    @IBOutlet weak var bestscoreLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func tappedSaveButton(_ sender: Any) {
        updateFirestoreData()
        navigationController?.popViewController(animated: true)
        SEManage.shared.playSE(resource: "SE_pupo")
    }
    @IBAction func tappedChangeImageButton(_ sender: Any) {
        presentToModalView()
        SEManage.shared.playSE(resource: "SE_pupo")
    }
    
//MARK: -ライフサイクル
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTapGestureForProfileImage()
        nameTextField.addTarget(self, action: #selector(textFieldEditingChanged(textField:)), for: .editingChanged)
    }
    
    override func viewWillLayoutSubviews() {
        labelAndButtonResize()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
//MARK: -レイアウトセットアップ
    private func setupViews() {
        nameTextField.text = user!.name
        levelLabel.text = user!.level
        totalscoreLabel.text = String(user!.totalScore)
        bestscoreLabel.text = String(user!.bestScore)
        saveButton.layer.cornerRadius = 20
        profileImage.image = UIImage(named: user!.currentImage)
    }
    
    private func labelAndButtonResize() {
        let vHeight = self.view.bounds.height
        iconName.font = iconName.font.withSize(vHeight / 28)
        level.font = level.font.withSize(vHeight / 45)
        totalscore.font = totalscore.font.withSize(vHeight / 45)
        bestscore.font = bestscore.font.withSize(vHeight / 45)
        levelLabel.font = levelLabel.font.withSize(vHeight / 25)
        totalscoreLabel.font = totalscoreLabel.font.withSize(vHeight / 17)
        bestscoreLabel.font = bestscoreLabel.font.withSize(vHeight / 17)
        let fontsize = Int(saveButton.frame.size.height / 2.3)
        saveButton.titleLabel?.font = UIFont(name: "JK-Maru-Gothic-M", size: CGFloat(fontsize))
    }
 
//テキストフィールドの文字数制限
    @objc func textFieldEditingChanged(textField: UITextField) {
        guard let text = textField.text else { return }
        textField.text = String(text.prefix(maxLength))
    }
    
//MARK: -TapGesture
    private func setupTapGestureForProfileImage() {
        profileImage.isUserInteractionEnabled = true
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedProfileImage(_:)))
        profileImage.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
    }
    
    @objc func tappedProfileImage(_ sender: UITapGestureRecognizer) {
        SEManage.shared.playSE(resource: "SE_pupo")
        presentToModalView()
    }
    
//MARK: -Firebase
    private func fetchUserInfoFromFirebase() {
        let userRef = Firestore.firestore().collection("users").document(UserDefaults.standard.string(forKey: "uid")!)
        userRef.getDocument { [self] (document, err) in
            if let err = err {
                print("ユーザー情報の取得に失敗しました。\(err)")
            }
            guard let data = document!.data() else { return }
            self.user = User.init(dic: data)
            profileImage.image = UIImage(named: user!.currentImage)
        }
    }
    
    private func updateFirestoreData() {
        let userRef = Firestore.firestore().collection("users").document(UserDefaults.standard.string(forKey: "uid")!)
        userRef.updateData(["name" : nameTextField.text!]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    private func presentToModalView() {
        let modalView = storyboard?.instantiateViewController(identifier: "ModalProfileViewController") as! ModalProfileViewController
        modalView.presentationController?.delegate = self
        present(modalView, animated: true, completion: nil)
    }
    
}
//MARK: -extension
//モーダルがdismissした時に画像を更新するため
extension ProfileEditController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        fetchUserInfoFromFirebase()
    }
}
