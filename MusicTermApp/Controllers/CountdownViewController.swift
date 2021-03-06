//
//  CountdownViewController.swift
//  MusicTermApp
//
//  Created by Ui-Okuyama on 2021/08/29.
//

import Foundation
import UIKit

class CountdownViewController: UIViewController {
    
    @IBOutlet weak var countLabel: UILabel!
    
    var timer = Timer()
    var count = 0
    var countText = ["","3", "2", "1", "Start!","Start!"]
    
    var quizdata: String?
    var questionData: QuestionData?
    
//MARK: -ライフサイクル
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        countLabel.text = String(countText[0])
        getQuestionData()
    }
    
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
    
    override func viewWillLayoutSubviews() {
        countLabel.font = countLabel.font.withSize(self.view.bounds.height / 12)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startCountdown()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { 
            SEManage.shared.playSE(resource: "カウントダウン")
        }
    }
    
//MARK: -private関数
    private func startCountdown() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.count += 1
            self.countLabel.text = String(self.countText[self.count])
            
            if self.count == 5 {
                self.presentToQuestionViewController()
                timer.invalidate()
            }
        })
    }
    
    private func getQuestionData() {
        QuestionDataManage.nowQuestionIndex = 0
        QuestionDataManage.shared.loadQuestion(quizdata: quizdata!)
        questionData = QuestionDataManage.shared.nextQuestion()
    }
    
    private func presentToQuestionViewController() {
        let storyBoard = UIStoryboard(name: "Question", bundle: nil)
        let questionViewController = storyBoard.instantiateViewController(identifier: "QuestionViewController") as! QuestionViewController
        questionViewController.questionData = questionData
        questionViewController.quizdata = quizdata
        print(questionData!.question)
        navigationController?.pushViewController(questionViewController, animated: false)
    }
}
