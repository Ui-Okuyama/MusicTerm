//
//  QuestionHistory.swift
//  MusicTermApp
//
//  Created by 槙和馬 on 2021/09/03.
//

import Foundation
import RealmSwift

class AnswerLog: Object {
    
    static let realm = try! Realm()
    
    @objc dynamic var id = 0
    @objc dynamic var createdAt = NSDate(timeIntervalSince1970: 0)
    @objc dynamic var musicTerm = ""
    @objc dynamic var correctOrFalse = false
    @objc dynamic var musicTermMeaning = ""
}
