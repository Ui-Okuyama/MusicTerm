//
//  QuestionViewController.swift
//  MusicTermApp
//
//  Created by 槙和馬 on 2021/08/29.
//

import Foundation
import UIKit
import RealmSwift
import GoogleMobileAds

class QuestionViewController: UIViewController {
    
    let realm = try! Realm()
    var questionData: QuestionData?
    var quizdata: String!
    var progressbarTimer: Timer? = nil
    var limitTimer: Timer? = nil
    var countdownBarFloat: Float = 1.00
    var solvedtime: Double!
    var timeStartingToSolve: Date!
    var timeFinisedToSolve: Date!
    var score: Int = 0
    var totalScore: Int = 0
    
    @IBOutlet weak var QuestionLabel: UILabel!
    @IBOutlet weak var countdownBar: UIProgressView!
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    @IBOutlet weak var remainingQuestionOfNumber: UILabel!
    @IBOutlet weak var backHomeButton: UIButton!
    @IBOutlet weak var nokoriLabel: UILabel!
    @IBOutlet weak var monnLabel: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var answerView: UIView!
    @IBOutlet weak var correctOrFalseLabel: UILabel!
    @IBOutlet weak var marubatsuImage: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBAction func tappedBackHomeButton(_ sender: Any) {
        presentToHomeViewController()
        resetTimer()
    }
    @IBAction func tappedAnswerButton1(_ sender: Any) {
        questionData?.userChoiceAnswer = answerButton1.currentTitle
        afterTappedAnswerButton()
    }
    @IBAction func tappedAnswerButton2(_ sender: Any) {
        questionData?.userChoiceAnswer = answerButton2.currentTitle
        afterTappedAnswerButton()
    }
    @IBAction func tappedAnswerButton3(_ sender: Any) {
        questionData?.userChoiceAnswer = answerButton3.currentTitle
        afterTappedAnswerButton()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillLayoutSubviews() {
        labelAndButtonResize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setTimer()
    }
    
    private func setup() {
        setQuestionLayout()
        answerButton1.layer.cornerRadius = 10
        answerButton2.layer.cornerRadius = 10
        answerButton3.layer.cornerRadius = 10
        backHomeButton.layer.cornerRadius = 15
        answerView.layer.borderColor = CGColor.rgb(red: 66, green: 92, blue: 58, alpha: 1)
        answerView.layer.borderWidth = 10
        answerView.layer.cornerRadius = 20
    }
    
    private func setQuestionLayout() {
        QuestionLabel.text = questionData?.question
        var choices = [questionData?.answer1, questionData?.answer2, questionData?.answer3]
        choices = choices.shuffled()
        UIView.setAnimationsEnabled(false)
        answerButton1.setTitle(choices[0], for: .normal)
        answerButton1.layoutIfNeeded()
        answerButton2.setTitle(choices[1], for: .normal)
        answerButton2.layoutIfNeeded()
        answerButton3.setTitle(choices[2], for: .normal)
        answerButton3.layoutIfNeeded()
        UIView.setAnimationsEnabled(true)
        remainingQuestionOfNumber.text = String(15 - QuestionDataManage.nowQuestionIndex)
        countdownBarFloat = 1.00
        countdownBar.progress = 1
    }
    
    private func setupBanner() {
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    private func labelAndButtonResize() {
        let vHeight = self.view.bounds.height
        QuestionLabel.font = QuestionLabel.font.withSize( vHeight / 35 )
        nokoriLabel.font = nokoriLabel.font.withSize( vHeight / 47 )
        monnLabel.font = monnLabel.font.withSize( vHeight / 47 )
        remainingQuestionOfNumber.font = remainingQuestionOfNumber.font.withSize( vHeight / 25 )
        let fontsize = Int(answerButton1.frame.size.height / 2.5)
        answerButton1.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(fontsize))
        answerButton2.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(fontsize))
        answerButton3.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(fontsize))
        let backfontsize = Int(answerButton1.frame.size.height / 2.5)
        backHomeButton.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(backfontsize))
        correctOrFalseLabel.font = QuestionLabel.font.withSize( vHeight / 22 )
        answerLabel.font = answerLabel.font.withSize( vHeight / 35 )
    }
    
    private func setTimer() {
        timeStartingToSolve = Date()
        
        progressbarTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(moveProgressBar), userInfo: nil, repeats: true)
        
        limitTimer = Timer.scheduledTimer(timeInterval: 5.05, target: self, selector: #selector(doneTimer), userInfo: nil, repeats: true)
    }
    
    @objc func moveProgressBar() {
        countdownBarFloat = countdownBarFloat - 0.01
        countdownBar.setProgress(countdownBarFloat, animated: true)
    }
    
    @objc func doneTimer() {
        afterTappedAnswerButton()
    }
    
    private func resetTimer() {
        progressbarTimer?.invalidate()
        limitTimer?.invalidate()
    }
    
    private func presentToHomeViewController() {
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController = storyBoard.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
        homeViewController.modalPresentationStyle = .fullScreen
        present(homeViewController, animated: true, completion: nil)
    }
    
    private func afterTappedAnswerButton() {
        allAnswerButtonDisabled()
        resetTimer()
        timeFinisedToSolve = Date()
        
        answerLabel.text = "答え：" + questionData!.answer1
        if questionData!.isCorrect() {
            print("correct")
            correctOrFalseLabel.text = " 正解!"
            marubatsuImage.image = UIImage(named: "maru")
            culcurateScore()
        } else {
            print("false")
            correctOrFalseLabel.text = " 不正解!"
            marubatsuImage.image = UIImage(named: "batsu")
            score = 0
            totalScore += score
        }
        answerView.alpha = 1
        saveToRealm()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.judgeGoingNextQuestionOrScore()
        }
    }
    
    private func culcurateScore() {
        solvedtime = 5 - (self.timeFinisedToSolve.timeIntervalSince(timeStartingToSolve))
        
        switch quizdata {
        case "quizdataEasy":
            score = 10
        case "quizdataNormal":
            score = 12
        case "quizdataHard":
            score = 14
        case "quizdataLunatic":
            score = 16
        default:
            break
        }
        score += Int(solvedtime * 2)
        totalScore += score
        print(score,totalScore,Int(solvedtime))
    }
    
    private func saveToRealm() {
        let questionHistory = QuestionHistory()
        questionHistory.createdAt = NSDate()
        questionHistory.musicTerm = questionData!.question
        questionHistory.correctOrFalse = questionData!.isCorrect()
        questionHistory.musicTermMeaning = questionData!.answer1
        print(questionHistory)
    }
    
    private func judgeGoingNextQuestionOrScore() {
        if QuestionDataManage.nowQuestionIndex == 14 {
            presentToHomeViewController()
        } else {
            GoNextQuestion()
        }
    }
    
    private func GoNextQuestion() {
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().sync {
            questionData = QuestionDataManage.shared.nextQuestion()
            setQuestionLayout()
            allAnswerButtonEnabled()
            score = 0
            solvedtime = 0
            semaphore.signal()
        }
        semaphore.wait()
        answerView.alpha = 0
        setTimer()
    }
    
    private func presentToScoreViewController() {
        
    }
    
    private func allAnswerButtonDisabled() {
        answerButton1.isEnabled = false
        answerButton2.isEnabled = false
        answerButton3.isEnabled = false
    }
    
    private func allAnswerButtonEnabled() {
        answerButton1.isEnabled = true
        answerButton2.isEnabled = true
        answerButton3.isEnabled = true
    }
    
    private func resetTimeAndScore() {
        score = 0
        solvedtime = 0
    }
}


