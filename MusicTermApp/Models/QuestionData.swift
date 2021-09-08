//
//  QuestionData.swift
//  MusicTermApp
//
//  Created by 槙和馬 on 2021/08/31.
//

import Foundation

class QuestionData {
    //問題文
    var question: String
    //選択肢
    var answer1: String
    var answer2: String
    var answer3: String
    
    var questionNo = 0
    var userChoiceAnswer: String? = ""
    
    init(questionDataSourceArray: Array<String>) {
        question = questionDataSourceArray[0]
        answer1 = questionDataSourceArray[1]
        answer2 = questionDataSourceArray[2]
        answer3 = questionDataSourceArray[3]
    }
    
    func isCorrect() -> Bool {
        userChoiceAnswer! == answer1
    }
}

class QuestionDataManage {
    
    static let shared = QuestionDataManage()
    var questionDataArray = [QuestionData]()
    static var nowQuestionIndex = 0
    var oneGameQuestionsArray:ArraySlice<QuestionData> = []
    
    func loadQuestion(quizdata: String) {
        guard let csvfilePath = Bundle.main.path(forResource: quizdata, ofType: "csv") else { print("csvファイルの読み込みができませんでした")
            return
        }
        questionDataArray.removeAll()
        oneGameQuestionsArray.removeAll()

        do {
            let csvStringData = try String(contentsOfFile: csvfilePath, encoding: String.Encoding.utf8)
            csvStringData.enumerateLines{(line, stop) in
                let questionDataSourceArray = line.components(separatedBy: ",")
                let questionData = QuestionData(questionDataSourceArray: questionDataSourceArray)
                self.questionDataArray.append(questionData)
                questionData.questionNo = self.questionDataArray.count + 1
            }
        } catch let err {
            print("csvファイルの取得に失敗\(err)")
            return
        }
        oneGameQuestionsArray = questionDataArray.shuffled().prefix(15)
    }
    
    func nextQuestion() -> QuestionData {
        let nextQuestion = oneGameQuestionsArray[QuestionDataManage.nowQuestionIndex]
        QuestionDataManage.nowQuestionIndex += 1
        return nextQuestion
    }
}
