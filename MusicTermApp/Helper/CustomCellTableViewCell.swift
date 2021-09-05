//
//  CustomCellTableViewCell.swift
//  MusicTermApp
//
//  Created by 槙和馬 on 2021/09/06.
//

import UIKit
import RealmSwift

class CustomCellTableViewCell: UITableViewCell {
    
    let realm = try! Realm()
        
    @IBOutlet weak var correctFalseView: UIImageView!
    @IBOutlet weak var musicTermLabel: UILabel!
    @IBOutlet weak var meaningLabel: UILabel!
    
    override func awakeFromNib() {
            super.awakeFromNib()
    }
    
    func setTextandImage(indexPath: IndexPath) {
        let allData = realm.objects(QuestionHistory.self).sorted(byKeyPath: "id", ascending: false)
        let cellData = allData[indexPath.row]
        self.musicTermLabel.text = cellData.musicTerm
        self.meaningLabel.text = cellData.musicTermMeaning
        if cellData.correctOrFalse {
            self.correctFalseView.image = UIImage(named: "maru")
        } else {
            self.correctFalseView.image = UIImage(named: "batsu")
        }
    }
    
}
