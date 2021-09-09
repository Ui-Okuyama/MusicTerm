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
    var  lowestScore: Int
    let levelText = ["かけだし","2","3","4","5","6","7","8","9","10","11","12","Max"]
    
    init (level:String) {
        switch level {
        case "かけだし":
            currentLevel = 1
            nextlevelScore = 10000
            lowestScore = 0
        case "2":
            currentLevel = 2
            nextlevelScore = 25000
            lowestScore = 10001
        case "3":
            currentLevel = 3
            nextlevelScore = 45000
            lowestScore = 25001
        case "4":
            currentLevel = 4
            nextlevelScore = 70000
            lowestScore = 45001
        case "5":
            currentLevel = 5
            nextlevelScore = 100000
            lowestScore = 70001
        case "6":
            currentLevel = 6
            nextlevelScore = 150000
            lowestScore = 100001
        case "7":
            currentLevel = 7
            nextlevelScore = 300000
            lowestScore = 150001
        case "8":
            currentLevel = 8
            nextlevelScore = 500000
            lowestScore = 300001
        case "9":
            currentLevel = 9
            nextlevelScore = 800000
            lowestScore = 500001
        case "10":
            currentLevel = 10
            nextlevelScore = 1300000
            lowestScore = 800001
        case "11":
            currentLevel = 11
            nextlevelScore = 2000000
            lowestScore = 1300001
        case "12":
            currentLevel = 12
            nextlevelScore = 5000000
            lowestScore = 2000001
        case "Max":
            currentLevel = 13
            nextlevelScore = 5000001
            lowestScore = 5000001
        default:
            currentLevel = 1
            nextlevelScore = 10000
            lowestScore = 0
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
        let nextLevelName = levelText[currentLevel + 2]
        return nextLevelName
    }
}
