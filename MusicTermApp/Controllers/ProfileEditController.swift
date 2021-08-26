//
//  ProfileEditController.swift
//  MusicTermApp
//
//  Created by 槙和馬 on 2021/08/23.
//

import Foundation
import UIKit
import Firebase

class ProfileEditController: UIViewController {
    var user:User?
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var totalscoreLabel: UILabel!
    @IBOutlet weak var bestscoreLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBAction func tappedSaveButton(_ sender: Any) {
        updateFirestoreData()
        navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        nameTextField.text = user!.name
        levelLabel.text = user!.level
        totalscoreLabel.text = String(user!.totalScore)
        bestscoreLabel.text = String(user!.bestScore)
        saveButton.layer.cornerRadius = 20
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
}
