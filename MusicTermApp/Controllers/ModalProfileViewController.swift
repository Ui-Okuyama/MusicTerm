//
//  ModalProfileViewController.swift
//  MusicTermApp
//
//  Created by 槙和馬 on 2021/08/27.
//

import Foundation
import UIKit
import Firebase

class ModalProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var images = UserDefaults.standard.array(forKey: "images")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserImagesFromFirebase()
        print(images!)
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        collectionView.collectionViewLayout = layout
    }
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    func fetchUserImagesFromFirebase() {
        let userRef = Firestore.firestore().collection("users").document(UserDefaults.standard.string(forKey: "uid")!)
        userRef.getDocument { [self] (document, err) in
            if let err = err {
                print("ユーザー情報の取得に失敗しました。\(err)")
            }
            guard let data = document!.data() else { return }
            images = (data["images"] as! Array<String>)
            print(images!)
        }
    }
    
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
        label.text = images![indexPath.row] as! String
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = 130
        return CGSize(width: cellSize, height: cellSize)
    }
}
