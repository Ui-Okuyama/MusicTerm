//
//  LevelUpViewController.swift
//  MusicTermApp
//
//  Created by 槙和馬 on 2021/09/09.
//

import Foundation
import UIKit
import Firebase

class LevelUpViewController: UIViewController {
    
    var level:Level?
    var tapCount = 0
    var levelText:String?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var levelUpImageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    @IBAction func tappedCloseButton(_ sender: Any) {
        SEManage.shared.playSE(resource: "SE_pupo")
        tapCount += 1
        tappedButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        SEManage.shared.playSE(resource: "レベルアップ")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    private func setup() {
        titleLabel.text = levelText! + "\nレベル"
    }
    
    private func labelAndButtonResize() {
        let vHeight = self.view.bounds.height
        titleLabel.font = titleLabel.font.withSize( vHeight / 35)
        closeButton.titleLabel?.font = UIFont(name: "JK-Maru-Gothic-R", size: vHeight / 27)
    }
    
    private func tappedButton() {
        if tapCount == 1 {
            levelUpImageView.image = UIImage(named: level!.getImage)
            titleLabel.text = "\(level!.getImage)を\n選択できるようになりました！"
            closeButton.setTitle("閉じる", for: .normal)
            updateImages()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func updateImages() {
        Firestore.firestore().collection("users").document(UserDefaults.standard.string(forKey: "uid")!).updateData(["images": FieldValue.arrayUnion([level!.getImage])]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            }
        }
    }
}

extension LevelUpViewController {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        guard let presentationController = presentationController else {
            return
        }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }
}
