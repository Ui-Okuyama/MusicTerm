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
    var getImage: String
    let levelText = ["1","2","3","4","5","6","7","8","9","10","11","12","Max"]
    
    init (level:String) {
        switch level {
        case "1":
            currentLevel = 1
            nextlevelScore = 1000
            lowestScore = 0
            getImage = "Brahms"
        case "2":
            currentLevel = 2
            nextlevelScore = 2500
            lowestScore = 1001
            getImage = "Brahms"
        case "3":
            currentLevel = 3
            nextlevelScore = 4500
            lowestScore = 2501
            getImage = "Brahms"
        case "4":
            currentLevel = 4
            nextlevelScore = 70000
            lowestScore = 4501
            getImage = "Brahms"
        case "5":
            currentLevel = 5
            nextlevelScore = 100000
            lowestScore = 70001
            getImage = "Brahms"
        case "6":
            currentLevel = 6
            nextlevelScore = 150000
            lowestScore = 100001
            getImage = "Brahms"
        case "7":
            currentLevel = 7
            nextlevelScore = 300000
            lowestScore = 150001
            getImage = "Brahms"
        case "8":
            currentLevel = 8
            nextlevelScore = 500000
            lowestScore = 300001
            getImage = "Brahms"
        case "9":
            currentLevel = 9
            nextlevelScore = 800000
            lowestScore = 500001
            getImage = "Brahms"
        case "10":
            currentLevel = 10
            nextlevelScore = 1300000
            lowestScore = 800001
            getImage = "Brahms"
        case "11":
            currentLevel = 11
            nextlevelScore = 2000000
            lowestScore = 1300001
            getImage = "Brahms"
        case "12":
            currentLevel = 12
            nextlevelScore = 5000000
            lowestScore = 2000001
            getImage = "Brahms"
        case "Max":
            currentLevel = 13
            nextlevelScore = 5000001
            lowestScore = 5000001
            getImage = "Brahms"
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
}
