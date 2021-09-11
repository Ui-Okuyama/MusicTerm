//
//  LevelUpViewController.swift
//  MusicTermApp
//
//  Created by 槙和馬 on 2021/09/09.
//

import Foundation
import UIKit

class LevelUpViewController: UIViewController {
    
    var level:Level?
    var tapCount = 0
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var levelUpImageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    @IBAction func tappedCloseButton(_ sender: Any) {
        tapCount += 1
        tappedButton()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        titleLabel.text = "Lv." + String(level!.currentLevel + 1)
    }
    
    private func tappedButton() {
        if tapCount == 1 {
            levelUpImageView.image = UIImage(named: level!.getImage)
            titleLabel.text = "新しいサムネイルを取得しました！"
            closeButton.setTitle("閉じる", for: .normal)
            
        } else {
            dismiss(animated: true, completion: nil)
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
