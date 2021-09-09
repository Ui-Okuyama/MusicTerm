//
//  LevelUpViewController.swift
//  MusicTermApp
//
//  Created by 槙和馬 on 2021/09/09.
//

import Foundation
import UIKit

class LevelUpViewController: UIViewController {
    
    @IBOutlet weak var levelUpImageView: UIImageView!
    @IBAction func tappedCloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
