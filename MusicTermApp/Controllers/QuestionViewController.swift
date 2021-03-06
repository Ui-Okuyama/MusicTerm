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
    var score: Double = 0
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
    @IBOutlet weak var marubatsuImage: UIImageView!
    
    @IBAction func tappedBackHomeButton(_ sender: Any) {
        presentToHomeViewController()
        resetTimer()
        SoundManage.shared.stopBgm()
        SEManage.shared.playSE(resource: "SE_pupo")
        SoundManage.shared.playBgm(resource: "BeethovenPop")
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
    
//MARK: -ライフサイクル
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupBanner()
        SoundManage.shared.playBgm(resource: "MozartPop")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationController?.navigationBar.isHidden = true
        labelAndButtonResize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setTimer()
    }
//MARK: -レイアウトセットアップ
    private func setup() {
        setQuestionLayout()
        answerButton1.layer.cornerRadius = 10
        answerButton2.layer.cornerRadius = 10
        answerButton3.layer.cornerRadius = 10
        backHomeButton.layer.cornerRadius = 15
    }
    
    private func setQuestionLayout() {
        QuestionLabel.text = questionData?.question
        var choices = [questionData?.answer1, questionData?.answer2, questionData?.answer3]
        choices = choices.shuffled() //選択肢の順番をランダムに
        UIView.setAnimationsEnabled(false) //問題が変わるときのアニメーションをなくす
        answerButton1.setTitle(choices[0], for: .normal)
        answerButton1.layer.borderWidth = 0
        answerButton1.layoutIfNeeded()
        answerButton2.setTitle(choices[1], for: .normal)
        answerButton2.layer.borderWidth = 0
        answerButton2.layoutIfNeeded()
        answerButton3.setTitle(choices[2], for: .normal)
        answerButton3.layer.borderWidth = 0
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
        let fontsize = Int(answerButton1.frame.size.width / 19 )
        answerButton1.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(fontsize))
        answerButton2.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(fontsize))
        answerButton3.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(fontsize))
        let backfontsize = Int(answerButton1.frame.size.height / 3)
        backHomeButton.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(backfontsize))
    }
//MARK: -タイマー系
    private func setTimer() {
        timeStartingToSolve = Date()
        //barのゲージを動かすためのタイマー
        progressbarTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(moveProgressBar), userInfo: nil, repeats: true)
        //時間切れの時に不正解&次の問題に変えるためのタイマー
        limitTimer = Timer.scheduledTimer(timeInterval: 5.05, target: self, selector: #selector(doneTimer), userInfo: nil, repeats: true)
    }
    
    @objc func moveProgressBar() {
        countdownBarFloat = countdownBarFloat - 0.01
        countdownBar.setProgress(countdownBarFloat, animated: true)
    }
    
    @objc func doneTimer() {
        allAnswerButtonEnabled()
        afterTappedAnswerButton()
    }
    
    private func resetTimer() {
        progressbarTimer?.invalidate()
        limitTimer?.invalidate()
    }
//MARK: -ユーザーが答えを選択した後
    private func afterTappedAnswerButton() {
        allAnswerButtonDisabled()
        resetTimer()
        timeFinisedToSolve = Date() //解答時間を計算するための
        
        if questionData!.isCorrect() {
            SEManage.shared.playSE(resource: "クイズ正解")
            marubatsuImage.image = UIImage(named: "maru")
            marubatsuImage.tintColor = UIColor.rgb(red: 104, green: 178, blue: 30, alpha: 1)
            culcurateScore()
        } else {
            SEManage.shared.playSE(resource: "クイズ不正解")
            marubatsuImage.image = UIImage(named: "batsu")
            marubatsuImage.tintColor = UIColor.rgb(red: 222, green: 101, blue: 74, alpha: 1)
        }
        saveToRealm()
        marubatsuImage.alpha = 0.7
        changeColorAnswerButton(button: answerButton1)
        changeColorAnswerButton(button: answerButton2)
        changeColorAnswerButton(button: answerButton3)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.judgeGoingNextQuestionOrScoreView()
        }
    }
    
    private func changeColorAnswerButton(button: UIButton) {
        //正解のボタンは枠を緑に、不正解のボタンは字を消す
        if questionData?.answer1 == button.currentTitle {
            button.layer.borderWidth = 4
            button.layer.borderColor = CGColor.rgb(red: 104, green: 178, blue: 30, alpha: 1)
        } else {
            button.setTitle("", for: .normal)
        }
    }
//MARK: -スコア計算
    private func culcurateScore() {
        solvedtime = 5 - (self.timeFinisedToSolve.timeIntervalSince(timeStartingToSolve))
        
        switch quizdata {
        case "quizdataEasy":
            score = 250
        case "quizdataNormal":
            score = 500
        case "quizdataHard":
            score = 1000
        case "quizdataLunatic":
            score = 2000
        default:
            break
        }
        totalScore += Int(score * solvedtime)
        print(score,totalScore,Int(solvedtime))
    }
//解答した問題のリストを別画面のリストビューで表示するため
    private func saveToRealm() {
        let allData = realm.objects(AnswerLog.self)
        let answerLog = AnswerLog()
        answerLog.id = allData.count + 1
        answerLog.createdAt = NSDate()
        answerLog.musicTerm = questionData!.question
        answerLog.correctOrFalse = questionData!.isCorrect()
        answerLog.musicTermMeaning = questionData!.answer1
        do {
            try realm.write{
                realm.add(answerLog)
            }
        } catch {
            print("err:\(error)")
        }
    }
//MARK: -次の問題に移る
    private func judgeGoingNextQuestionOrScoreView() {
        if QuestionDataManage.nowQuestionIndex == 15 {
            presentToScoreViewController()
        } else {
            GoNextQuestion()
        }
    }
    
    private func GoNextQuestion() {
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().sync {
            questionData = QuestionDataManage.shared.nextQuestion()
            setQuestionLayout()
            marubatsuImage.alpha = 0
            allAnswerButtonEnabled()
            score = 0
            solvedtime = 0
            semaphore.signal()
        }
        semaphore.wait()
        setTimer()
    }
//MARK: -画面遷移の関数
    private func presentToScoreViewController() {
        let storyboards = UIStoryboard(name: "Result", bundle: nil)
        let resultViewController = storyboards.instantiateViewController(identifier: "ResultViewController") as! ResultViewController
        resultViewController.modalPresentationStyle = .fullScreen
        resultViewController.score = totalScore
        SoundManage.shared.stopBgm()
        print(totalScore)
        navigationController?.pushViewController(resultViewController, animated: true)
    }
    
    private func presentToHomeViewController() {
        navigationController?.popToViewController(navigationController!.viewControllers[1], animated: true)
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
}
