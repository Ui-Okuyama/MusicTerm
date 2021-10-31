//
//  ModalProfileViewController.swift
//  MusicTermApp
//
//  Created by 槙和馬 on 2021/08/27.
//

import Foundation
import UIKit
import Firebase

class ModalProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    var user:User?
    var images = UserDefaults.standard.array(forKey: "images")
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    
//MARK: -ライフサイクル
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTapGesture()
    }
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        layoutsetup()
        self.view.layoutIfNeeded()
    }
    
//MARK: -private関数
    private func setup() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.minimumInteritemSpacing = 0
        collectionView.collectionViewLayout = layout
    }
    
    private func layoutsetup() {
        let rowOfNumber = 18 / (Int(view.bounds.width - 80) / 140)
        collectionView.frame.size.height = CGFloat(180 * rowOfNumber + 150)
        print(Int(collectionView.frame.size.height))
        if scrollView.frame.size.height > collectionView.frame.size.height {
            scrollView.frame.size.height = collectionView.frame.size.height
        }
    }
    
    private func fetchUserInfoFromFirebase() {
        let userRef = Firestore.firestore().collection("users").document(UserDefaults.standard.string(forKey: "uid")!)
        userRef.getDocument { [self] (document, err) in
            if let err = err {
                print("ユーザー情報の取得に失敗しました。\(err)")
            }
            guard let data = document!.data() else { return }
            self.user = User.init(dic: data)
        }
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissModal))
        self.view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
    }
// モーダル外をタップ時にdismiss
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view!.isDescendant(of: scrollView)) {
            return false
        } else {
            return true
        }
    }
    
    @objc func dismissModal() {
        dismiss(animated: true)
    }
    
//MARK: -コレクションビュー
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        let cellImage = UIImage(named: images![indexPath.row] as! String)
        imageView.frame = CGRect(x: 10, y: 20, width: 130, height: 130)
        imageView.image = cellImage
        
        
        let label = cell.contentView.viewWithTag(2) as! UILabel
        label.text = images![indexPath.row] as? String
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        SEManage.shared.playSE(resource: "SE_pupo")
        let selectImage = images![indexPath.row]
        let userRef = Firestore.firestore().collection("users").document(UserDefaults.standard.string(forKey: "uid")!)
        userRef.updateData(["currentImage" : selectImage]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        fetchUserInfoFromFirebase()
        dismiss(animated: true, completion: nil)
    }
    
}
//MARK: -Extension
extension ModalProfileViewController {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        guard let presentationController = presentationController else {
            return
        }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }
}
