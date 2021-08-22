//
//  ViewController.swift
//  MusicTermApp
//
//  Created by 槙和馬 on 2021/08/22.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
    @IBAction func touchdownStartButton(_ sender: Any) {
        startButton.backgroundColor = UIColor.rgb(red: 200, green: 108, blue: 0, alpha: 1)
    }
    @IBAction func tappedStartButton(_ sender: Any) {
        startButton.backgroundColor = UIColor.rgb(red: 255, green: 149, blue: 0, alpha: 1)
        print()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        startButton.layer.cornerRadius = 20
        let icon = UIImage(systemName: "gearshape.fill")
        settingButton.setImage(icon, for: .normal)
    }
    
}

