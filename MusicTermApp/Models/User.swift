//
//  User.swift
//  MusicTermApp
//
//  Created by 槙和馬 on 2021/08/22.
//

import Foundation
import Firebase

struct User {
    var name: String
    var totalScore: Int
    var bestScore: Int
    var level: String
    var imageNumber: Int
    
    
    init(dic: [String: Any]) {
        self.name = dic["name"] as! String
        self.totalScore = dic["totalScore"] as! Int
        self.bestScore = dic["bestScore"] as! Int
        self.level = dic["level"] as! String
        self.imageNumber = dic["imageNumber"] as! Int
    }
}

