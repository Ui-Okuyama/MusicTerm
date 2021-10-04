//
//  Level.swift
//  MusicTermApp
//
//  Created by 槙和馬 on 2021/09/09.
//

import Foundation

struct Level {
    
    var currentLevel: Int
    var nextlevelScore: Int
    var lowestScore: Int
    var getImage: String
    let levelText = ["はじめまして！","まだまだひよっこ","少し慣れてきた","楽語？まぁまぁ知ってるよ","音楽好きの平均","一人前の楽語イスト","ステキな楽語イスト","楽語に夢中","専科は楽器？それとも…楽語？","楽語愛を叫びたい！","どこまで極めるつもり？","楽語と共に生きていくんだ","究極の楽語マスター"]
    
    init (level:String) {
        switch level {
        case "はじめまして！":
            currentLevel = 1
            nextlevelScore = 10000
            lowestScore = 0
            getImage = "Brahms"
        case "まだまだひよっこ":
            currentLevel = 2
            nextlevelScore = 30000
            lowestScore = 10001
            getImage = "Haydn"
        case "少し慣れてきた":
            currentLevel = 3
            nextlevelScore = 60000
            lowestScore = 30001
            getImage = "Schubert"
        case "楽語？まぁまぁ知ってるよ":
            currentLevel = 4
            nextlevelScore = 100000
            lowestScore = 60001
            getImage = "Ravel"
        case "音楽好きの平均":
            currentLevel = 5
            nextlevelScore = 150000
            lowestScore = 100001
            getImage = "Schumann"
        case "一人前の楽語イスト":
            currentLevel = 6
            nextlevelScore = 250000
            lowestScore = 120001
            getImage = "Liszt"
        case "ステキな楽語イスト":
            currentLevel = 7
            nextlevelScore = 500000
            lowestScore = 250001
            getImage = "Paganini"
        case "楽語に夢中":
            currentLevel = 8
            nextlevelScore = 1000000
            lowestScore = 500001
            getImage = "Handel"
        case "専科は楽器？それとも…楽語？":
            currentLevel = 9
            nextlevelScore = 2000000
            lowestScore = 1000001
            getImage = "Grieg"
        case "楽語愛を叫びたい！":
            currentLevel = 10
            nextlevelScore = 4000000
            lowestScore = 2000001
            getImage = "Saint-Saens"
        case "どこまで極めるつもり？":
            currentLevel = 11
            nextlevelScore = 8000000
            lowestScore = 4000001
            getImage = "Mendelssohn"
        case "楽語と共に生きていくんだ":
            currentLevel = 12
            nextlevelScore = 15000000
            lowestScore = 8000001
            getImage = "Prokofiev"
        case "究極の楽語マスター":
            currentLevel = 13
            nextlevelScore = 1000000000 // バリデーションがあるため到達不可能な値
            lowestScore = 15000001
            getImage = ""
        default:
            currentLevel = 1
            nextlevelScore = 10000
            lowestScore = 0
            getImage = "Brahms"
        }
    }
    
    func jugdeNextLevel(totalScore:Int) -> Bool {
        if totalScore > nextlevelScore {
            return true
        } else {
            return false
        }
    }
    
    func nextLevelName() -> String {
        let nextLevelName = levelText[currentLevel]
        return nextLevelName
    }
    
    func culcurateProgressRate(totalScore: Int) -> Float {
        let rate = Float(totalScore - lowestScore) / Float(nextlevelScore - lowestScore)
        return Float(rate)
    }
}
