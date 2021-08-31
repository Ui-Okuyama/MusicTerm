//
//  QuestionViewController.swift
//  MusicTermApp
//
//  Created by 槙和馬 on 2021/08/29.
//

import Foundation
import UIKit

class QuestionViewController: UIViewController {
    
    var questionData: QuestionData?
    
    @IBOutlet weak var QuestionLabel: UILabel!
    @IBOutlet weak var countdownBar: UIProgressView!
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    @IBOutlet weak var remainingQuestionOfNumber: UILabel!
    @IBOutlet weak var backHomeButton: UIButton!
    @IBOutlet weak var nokoriLabel: UILabel!
    @IBOutlet weak var monnLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        print(questionData!.question)
    }
}
